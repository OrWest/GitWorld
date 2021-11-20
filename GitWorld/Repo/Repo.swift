//
//  Repo.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 28.10.21.
//

import Foundation
import ObjectiveGit

class RepoCancel {
    private(set) var isCancelled = false
    
    func cancel() {
        isCancelled = true
    }
}

enum RepoError: Error {
    case cloneError(Error)
}

class Repo {
    private let gitCancelErrorCode = -7
    
    private let fileManager: FileManager
    private let gitURL: URL
    let localURL: URL
    private(set) var cloned: Bool
    private var repo: GTRepository?

    init?(gitURL: URL, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.gitURL = gitURL
        
        guard let rootURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.log("[REPO] Can't find document folder")
            return nil
        }
        
        let lastComponent = gitURL.lastPathComponent
        let folderNameParts = lastComponent.split(separator: ".", maxSplits: 1)
        
        let folderName: String
        if folderNameParts.count == 2, folderNameParts[1] == "git" {
            folderName = String(folderNameParts.first!)
        } else {
            folderName = lastComponent
        }
        
        self.localURL = rootURL.appendingPathComponent(folderName)
        
        do {
            repo = try GTRepository.init(url: localURL)
            cloned = true
            Logger.log("[REPO] Initialized locally: \(localURL.lastPathComponent)")
        } catch {
            if (error as NSError).code == -3 { // No such directory error. Clone
                Logger.log("[REPO] \(localURL.lastPathComponent) repo is not cloned.")
                cloned = false
            } else {
                Logger.log("[REPO] \(localURL.lastPathComponent) initialization failed: \(error)")
                return nil
            }
        }
    }
    
    init(url: URL, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.gitURL = url
        self.localURL = url
        self.cloned = true
    }
    
    func cloneRepo(repoCancel: RepoCancel, progressBlock: @escaping (Int, Int) -> Void) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                
                self.deleteRepoIfExist()
                
                do {
                    Logger.log("[REPO] Clone \(self.gitURL.relativePath)")
                    self.repo = try GTRepository.clone(from: self.gitURL, toWorkingDirectory: self.localURL, options: nil) { progressPointer, stop in
                        guard !repoCancel.isCancelled else {
                            stop.pointee = ObjCBool(repoCancel.isCancelled)
                            return
                        }
                        
                        let progress = progressPointer.pointee
                        progressBlock(Int(progress.received_objects), Int(progress.total_objects))
                        Logger.log("Clone progress: \(progress.received_objects)/\(progress.total_objects)")
                    }
                    self.cloned = true
                    Logger.log("[Repo] \(self.localURL.lastPathComponent) cloned")
                    continuation.resume()
                } catch {
                    if (error as NSError).code == self.gitCancelErrorCode {
                        Logger.log("[REPO] \(self.localURL.lastPathComponent) clone cancelled")
                        continuation.resume()
                    } else {
                        Logger.log("[REPO] \(self.localURL.lastPathComponent) clone error: \(error)")
                        continuation.resume(throwing: RepoError.cloneError(error))
                    }
                }
            }
        }
        
    }
    
    func deleteRepoIfExist() {
        guard fileManager.fileExists(atPath: localURL.absoluteURL.relativePath) else {
            Logger.log("[Repo] No folder with such name (\(localURL.deletingPathExtension().lastPathComponent)). Ignore.")
            return
        }
        
        Logger.log("[Repo] Delete local repo: \(localURL)")
        do {
            try fileManager.removeItem(at: localURL)
        } catch {
            Logger.log("[Repo] Can't delete repo: \(error)")
        }
    }
}
