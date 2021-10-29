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
    private let filesURL: [URL]
    
    init(localURL: URL, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.localURL = localURL
        self.filesURL = RepoAnalyzer.getFilesPathsToAnalyze(fileManager: fileManager, localURL: localURL)
    }
    
    private static func getFilesPathsToAnalyze(fileManager: FileManager, localURL: URL) -> [URL] {
        filesURL = fileManager.contentsOfDirectory(at: localURL, includingPropertiesForKeys: nil, options: [])
    }
}
