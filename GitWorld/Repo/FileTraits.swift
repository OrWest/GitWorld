//
//  FileTraits.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 29.10.21.
//

import Foundation

enum FileType {
    case general
    case readme
    case license
    case gitignore
    case travis
    case packageManager(String)
    case documentation(String)
    case test
}

class FileTraits {
    private(set) var type: FileType = .general
    let lineCount: Int
    let fileName: String
    
    init(url: URL) {
        fileName = url.lastPathComponent
        lineCount = ReadStream(url: url).reduce(0) { counter, _ in return counter + 1 }
        
        let uppercasedFileName = url.lastPathComponent.lowercased()
        let nameComponents = uppercasedFileName.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
        let fileExt = nameComponents[safe: 1].map { String($0) }
        let name = String(nameComponents.first!)
        
        switch (name, fileExt) {
            case ("", "travis.yml"): type = .travis
            case ("", "gitignore"): type = .gitignore
            case ("readme", _): type = .readme
            case ("license", _): type = .license
            case ("package", "swift"): type = .packageManager("Swift Package Manager")
            case ("Cartfile", _): type = .packageManager("Chartage")
            case (let name, "md"): type = .documentation(name)
            case (let name, _) where name.lowercased().contains("tests"): type = .test
            default: break
        }
    }
    
    init(fileName: String, linesCount: Int) {
        self.fileName = fileName
        self.lineCount = linesCount
    }
}
