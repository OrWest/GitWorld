//
//  RepoTraits.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 29.10.21.
//

import Foundation

class RepoTraits {
    private(set) var containsReadMe: Bool = false
    private(set) var containsTravis: Bool = false
    private(set) var containsGitignore: Bool = false
    private(set) var containsLicense: Bool = false
    private(set) var containsSwiftPackage: Bool = false
    private(set) var linesCount: Int = 0
    
    private(set) var fileTraits: [FileTraits] = []
    
    func accumulateTraits(traits: FileTraits) {
        fileTraits.append(traits)
        
        switch traits.type {
            case .readme: containsReadMe = true
            case .license: containsLicense = true
            case .gitignore: containsGitignore = true
            case .travis: containsTravis = true
            case .swiftPackage: containsSwiftPackage = true
            case .general: break
        }
        
        linesCount += traits.lineCount
    }
}
