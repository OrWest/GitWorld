//
//  RepoSetViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 1.11.21.
//

import Foundation
import SwiftUI

class RepoSetViewModel: ObservableObject {
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
    @Published var cloneProgress: Float = 0
    @Published var clonedCount = 0
    @Published var toCloneCount = 0
    @Published var isCloning = false
    
    @Published var analyzeProgress: Float = 0
    @Published var analyzedCount = 0
    @Published var toAnalyzeCount = 0
    @Published var isAnalyzing = false
    
    var cancelClone = false {
        didSet {
            if cancelClone {
                cancelObject?.cancel()
            }
        }
    }
    private var cancelObject: RepoCancel?
    
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
            
            isCloning = true
            Task.init {
                self.cancelObject = RepoCancel()
                defer {
                    DispatchQueue.main.async {
                        self.isCloning = false
                        self.cancelClone = false
                        self.cancelObject = nil
                        self.cloneProgress = 0
                        self.clonedCount = 0
                        self.toCloneCount = 0
                    }
                }
                do {
                    try await repo.cloneRepo(repoCancel: cancelObject!) { progress, cloned, toClone in
                        DispatchQueue.main.async {
                            self.cloneProgress = progress
                            self.clonedCount = cloned
                            self.toCloneCount = toClone                            
                        }
                    }
                    
                    let analyzer = RepoAnalyzer(localURL: repo.localURL)
                    await analyzer.analyze()
                    
                    let worldName = repo.localURL.deletingPathExtension().lastPathComponent
                    let worldGenerator = WorldGenerator(name: worldName)
                    let world = await worldGenerator.generate(repoTraits: analyzer.repoTraits)
                    
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
        let model = RepoSetViewModel()
        model.isCloning = cloning
        model.cloneProgress = progress
        model.clonedCount = cloned
        model.toCloneCount = toClone
        return model
    }
}
