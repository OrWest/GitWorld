//
//  RepoIgnore.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import Foundation

class RepoIgnore {
    let ignoreFolder: [String] = [
        ".git"
    ]
    
    func shouldIgnore(fileName: String, isDir: Bool) -> Bool {
        if isDir {
            return ignoreFolder.contains(fileName)
        } else {
            return false
        }
    }
}
