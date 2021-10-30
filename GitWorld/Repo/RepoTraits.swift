//
//  RepoTraits.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 29.10.21.
//

import Foundation

struct RepoFile {
    let name: String
    let linesCount: Int
    
    init(traits: FileTraits) {
        self.name = traits.fileName
        self.linesCount = traits.lineCount
    }
}

class RepoTraits {
    private(set) var containsReadMe: Bool = false
    private(set) var containsTravis: Bool = false
    private(set) var containsGitignore: Bool = false
    private(set) var containsLicense: Bool = false
    private(set) var containsSwiftPackage: Bool = false
    private(set) var linesCount: Int = 0
    private(set) var generalFiles: [RepoFile] = []
    
    private var files: [RepoFile] = []
    
    func accumulateTraits(traits: FileTraits) {
        
        switch traits.type {
            case .readme: containsReadMe = true
            case .license: containsLicense = true
            case .gitignore: containsGitignore = true
            case .travis: containsTravis = true
            case .swiftPackage: containsSwiftPackage = true
            case .general:
                files.append(RepoFile(traits: traits))
        }
        
        linesCount += traits.lineCount
    }
}

extension RepoTraits {
    static let stub: RepoTraits = {
        let traits = RepoTraits()
        traits.containsReadMe = true
        traits.containsTravis = true
        traits.containsGitignore = true
        traits.containsLicense = true
        traits.containsSwiftPackage = true

        traits.linesCount = Int.random(in: 0..<10000)
        traits.generalFiles = [
            FileTraits(fileName: "Text file", linesCount: Int.random(in: 0..<10000)),
            FileTraits(fileName: "Swift file long name name name name name name name!!!", linesCount: Int.random(in: 0..<10000)),
            FileTraits(fileName: "Lenovo", linesCount: Int.random(in: 0..<10000))
        ].map { RepoFile(traits: $0) }
        return traits
    }()
}
