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

class RepoTraits: CustomStringConvertible {
    private(set) var containsReadMe: Bool = false
    private(set) var containsTravis: Bool = false
    private(set) var containsGitignore: Bool = false
    private(set) var containsLicense: Bool = false
    private(set) var containsSwiftPackage: Bool = false
    private(set) var linesCount: Int = 0
    private(set) var generalFiles: [RepoFile] = []
        
    func accumulateTraits(traits: FileTraits) {
        
        switch traits.type {
            case .readme: containsReadMe = true
            case .license: containsLicense = true
            case .gitignore: containsGitignore = true
            case .travis: containsTravis = true
            case .packageManager: containsSwiftPackage = true
            case .documentation(_):
                break
            case .test:
                break
            case .general:
                generalFiles.append(RepoFile(traits: traits))
        }
        
        linesCount += traits.lineCount
    }
    
    var description: String {
        return """
        Line count: \(linesCount)
        Repo traits:
        \(repoTraitsString())
        General files:
        \(generalFiles.map { " \($0.name):\($0.linesCount)" }.joined(separator: "\n"))
        """
    }
    
    private func repoTraitsString() -> String {
        var result = ""
        let prefix = "\n "
        
        if containsReadMe {
            result.append(prefix)
            result.append("ReadME")
        }
        
        if containsTravis {
            result.append(prefix)
            result.append("Travis")
        }
        
        if containsGitignore {
            result.append(prefix)
            result.append("gitignore")
        }
        
        if containsLicense {
            result.append(prefix)
            result.append("License")
        }
        
        if containsSwiftPackage {
            result.append(prefix)
            result.append("Swift Package")
        }
        
        if result.count > 0 {
            result.removeFirst()
        }
        
        return result
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
