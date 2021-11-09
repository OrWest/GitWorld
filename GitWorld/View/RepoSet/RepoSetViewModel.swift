//
//  RepoSetViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 1.11.21.
//

import Foundation
import SwiftUI

class RepoSetViewModel: ObservableObject {
    class Progress: ObservableObject {
        @Published var madeCount: Int
        @Published var amount: Int
        @Published var progress: Float
        
        init(progress: Float = 0, madeCount: Int = 0, amount: Int = 0) {
            self.progress = progress
            self.madeCount = madeCount
            self.amount = amount
        }
    }
    
    enum Error: LocalizedError, Identifiable {
        var id: String {
            switch self {
                case .emptyURL: return "emptyURL"
                case .invalidURL: return "invalidURL"
                case .cantCreateRepo: return "cantCreateRepo"
                case .cloneError: return "cloneError"
            }
        }
        
        case emptyURL
        case invalidURL
        case cantCreateRepo
        case cloneError(Swift.Error)
        
        var errorDescription: String? {
            switch self {
                case .emptyURL:
                    return "Please, fill field with URL"
                case .invalidURL:
                    return "Invalid link. Check it starts with http or https"
                case .cantCreateRepo:
                    return "Can't create repo folder"
                case .cloneError(let error):
                    return "Clone error: \(error.localizedDescription)"
            }
        }
    }
    
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?
    @Published var cloneProgress: Progress?
    @Published var analyzeProgress: Progress?
    @Published var isGeneratingWorld = false
    
    private let context: AppContext
    private var cancelObject: RepoCancel?
    
    init(context: AppContext) {
        self.context = context
    }
    
    func cancelProcess() {
        cancelObject?.cancel()
    }
    
    func pullNewGit(_ url: String, errorBlock: @escaping (RepoSetViewModel.Error) -> Void) throws {
        guard !url.isEmpty else {
            throw Error.emptyURL
        }
        
        guard let urlObject = URL(string: url),
              urlObject.scheme == "http" ||
                urlObject.scheme == "https"
        else {
            throw Error.invalidURL
        }
        
        guard let repo = Repo(gitURL: urlObject) else {
            throw Error.cantCreateRepo
        }
        
        if repo.cloned {
            gitURLInSettings = url
        } else {
            
            let cloneProgress = Progress()
            self.cloneProgress = cloneProgress
            Task.init {
                defer {
                    cancelObject = nil
                    DispatchQueue.main.async {
                        self.cloneProgress = nil
                        self.analyzeProgress = nil
                        self.isGeneratingWorld = false
                    }
                }
                
                self.cancelObject = RepoCancel()
                do {
                    try await repo.cloneRepo(repoCancel: cancelObject!) { cloned, toClone in
                        DispatchQueue.main.async {
                            cloneProgress.progress = Float(cloned)/Float(toClone)
                            cloneProgress.amount = toClone
                            cloneProgress.madeCount = cloned
                        }
                    }
                    
                    let analyzeProgress = Progress()
                    DispatchQueue.main.async {
                        self.cloneProgress = nil
                        self.analyzeProgress = analyzeProgress
                    }
                    
                    guard !cancelObject!.isCancelled else { return }
                    
                    let analyzer = RepoAnalyzer(localURL: repo.localURL)
                    await analyzer.analyze { progress, count in
                        DispatchQueue.main.async {
                            analyzeProgress.progress = Float(progress)/Float(count)
                            analyzeProgress.amount = count
                            analyzeProgress.madeCount = progress
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.analyzeProgress = analyzeProgress
                        self.isGeneratingWorld = true
                    }
                    
                    guard !cancelObject!.isCancelled else { return }
                    
                    let worldName = repo.localURL.deletingPathExtension().lastPathComponent
                    let worldGenerator = WorldGenerator(name: worldName)
                    let world = await worldGenerator.generate(repoTraits: analyzer.repoTraits)
                    
                    DispatchQueue.main.async {
                        self.isGeneratingWorld = false
                    }
                    
                    context.repo = repo
                    context.world = world
                    
                    if !cancelObject!.isCancelled {
                        self.gitURLInSettings = url
                    }
                } catch {
                    errorBlock(Error.cloneError(error))
                }
            }
        }
    }
}


extension RepoSetViewModel {
    static func stub(cloning: Bool, progress: Float = 0.81, cloned: Int = 81, toClone: Int = 100) -> RepoSetViewModel {
        let model = RepoSetViewModel(context: AppContext())
        model.cloneProgress = Progress(progress: progress, madeCount: cloned, amount: toClone)
        return model
    }
}
