//
//  RepoAnalyzer.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 2021-10-29.
//

import Foundation

typealias RepoAnalyzerProgressBlock = (Int, Int) -> Void

class RepoAnalyzer {
    private let filesURL: [URL]
    
    private(set) var repoTraits = RepoTraits()
    
    init(localURL: URL, fileManager: FileManager = FileManager.default) {
        self.filesURL = RepoAnalyzer.getFilesPathsToAnalyze(fileManager: fileManager, localURL: localURL)
    }
    
    init(repoTraits: RepoTraits) {
        self.filesURL = []
        self.repoTraits = repoTraits
    }
    
    func analyze(progress: @escaping RepoAnalyzerProgressBlock) async {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let traits = self.analyzeFiles(urls: self.filesURL, progress: progress)
                self.repoTraits = traits
                Logger.log("\(traits)")
                continuation.resume()
            }
        }
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
                        Logger.log("[Analyzer] Ignore\(isDir ? " dir" : ""): \(url.lastPathComponent)")
                        continue
                    }
                    
                    if isDir {
                        Logger.log("[Analyzer] \(url.relativePath) is dir. Go inside.")
                        let urlsInDir = getFilesPathsToAnalyze(fileManager: fileManager, localURL: url)
                        filesURL.append(contentsOf: urlsInDir)
                    } else {
                        Logger.log("[Analyzer] File \(url.relativePath) is added.")
                        filesURL.append(url)
                    }
                } catch {
                    Logger.log("[Analyzer] Can't get resource properties from \(url.lastPathComponent): \(error)")
                    continue
                }
            }
            
            return filesURL
        } catch {
            Logger.log("[Analyzer]: Can't get files: \(error.localizedDescription)")
            return []
        }
    }
    
    private func analyzeFiles(urls: [URL], progress: RepoAnalyzerProgressBlock) -> RepoTraits {
        let count = urls.count
        let repoTraits = RepoTraits()
        for (i, url) in urls.enumerated() {
            progress(i, count)
            let traits = FileTraits(url: url)
            repoTraits.accumulateTraits(traits: traits)
        }
        return repoTraits
    }
}
