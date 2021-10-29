//
//  Repo.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 28.10.21.
//

import Foundation
import ObjectiveGit

enum RepoError: Error {
    case noDocumentFolder
    case cantCreateLocalFolder
    case gitError(Error)
}

class Repo {
    private let gitURL: URL
    private let localURL: URL
    private var repo: GTRepository?
    
    init(gitURL: URL) throws {
        self.gitURL = gitURL
        
        let fileManager = FileManager.default
        guard let rootURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw RepoError.noDocumentFolder
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
            throw RepoError.cantCreateLocalFolder
        }
        
        self.localURL = localURL
        
        try fetchRepo()
    }
    
    private func fetchRepo() throws {
        let repo: GTRepository
        do {
            repo = try GTRepository.init(url: localURL)
        } catch {
            if (error as NSError).code == -3 { // No such directory error. Clone
                repo = try GTRepository.clone(from: gitURL, toWorkingDirectory: localURL, options: nil, transferProgressBlock: nil)
            } else {
                throw RepoError.gitError(error)
            }
        }
        
//        let head = try! repo.headReference()
//        let lastCommit = try! repo.lookUpObject(by: head.targetOID!) as! GTCommit
//
//        print(lastCommit.message!)
    }
}
