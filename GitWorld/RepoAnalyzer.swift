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
    
    private(set) var repoTraits: RepoTraits
    
    init(localURL: URL, fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.localURL = localURL
        self.filesURL = RepoAnalyzer.getFilesPathsToAnalyze(fileManager: fileManager, localURL: localURL)
        self.repoTraits = RepoTraits()
        
        analyzeFiles(urls: filesURL)
    }
    
    private static func getFilesPathsToAnalyze(fileManager: FileManager, localURL: URL) -> [URL] {
        do {
            let urls = try fileManager.contentsOfDirectory(at: localURL, includingPropertiesForKeys: nil, options: [])
            
            var filesURL: [URL] = []
            for url in urls {
                do {
                    let values = try url.resourceValues(forKeys: [.isDirectoryKey])
                    let isDir = values.isDirectory ?? false
                    
                    guard !RepoIgnore().shouldIgnore(fileName: url.lastPathComponent, isDir: isDir) else {
                        print("Ignore\(isDir ? " dir" : ""): \(url.lastPathComponent)")
                        continue
                    }
                    
                    if isDir {
                        let urlsInDir = getFilesPathsToAnalyze(fileManager: fileManager, localURL: url)
                        filesURL.append(contentsOf: urlsInDir)
                    } else {
                        filesURL.append(url)
                    }
                } catch {
                    print("Can't get resource properties from \(url.lastPathComponent): \(error)")
                    continue
                }
            }
            
            return filesURL
        } catch {
            print("RepoAnalyzer: can't get files: \(error.localizedDescription)")
            return []
        }
    }
    
    private func analyzeFiles(urls: [URL]) {
        repoTraits = urls.map { FileTraits(url: $0) }.reduce(into: RepoTraits()) { $0.accumulateTraits(traits: $1) }
    }
}
