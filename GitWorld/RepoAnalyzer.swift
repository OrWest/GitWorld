//
//  RepoAnalyzer.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 2021-10-29.
//

import Foundation

class RepoAnalyzer {
    private let fileManager: FileManager
    private let localURL: URL
    
    init(localURL: URL, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.localURL = localURL
    }
    
}
