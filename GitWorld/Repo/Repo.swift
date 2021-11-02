//
//  Repo.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 28.10.21.
//

import Foundation
import ObjectiveGit

enum RepoError: Error {
    case cloneError(Error)
}

class Repo {
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
        
        guard let localURL = URL(string: folderName, relativeTo: rootURL) else {
            Logger.log("[REPO] Can't create local folder in documents")
            return nil
        }
        
        self.localURL = localURL
        
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
    
    func cloneRepo() throws {
        do {
            Logger.log("[REPO] Clone \(gitURL.relativePath)")
            repo = try GTRepository.clone(from: gitURL, toWorkingDirectory: localURL, options: nil) { progressPointer, _ in
                let progress = progressPointer.pointee
                Logger.log("Clone progress: \(progress.received_objects)/\(progress.total_objects)")
            }
            Logger.log("[Repo] \(localURL.lastPathComponent) cloned")
        } catch {
            Logger.log("[REPO] \(localURL.lastPathComponent) clone error: \(error)")
            throw RepoError.cloneError(error)
        }
                
//        let head = try! repo.headReference()
//        let lastCommit = try! repo.lookUpObject(by: head.targetOID!) as! GTCommit
//
//        print(lastCommit.message!)
    }
}
