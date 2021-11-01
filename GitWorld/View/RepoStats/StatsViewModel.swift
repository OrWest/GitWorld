//
//  StatsViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import Foundation

class StatsViewModel {
    struct Row {
        let text: String
        let imageName: String?
        let rightText: String?
    }
    
    var rows: [Row] = []
    
    init(traits: RepoTraits? = nil) {
        let repoTraits: RepoTraits
        if let traits = traits {
            repoTraits = traits
        } else {
            let repo: Repo
            do {
                repo = try Repo(gitURL: URL(string: "https://github.com/OrWest/SwiftAsyncOp")!)
            } catch {
                print("Can't initialize repo: \(error)")
                return
            }
            
            let analyzer = RepoAnalyzer(localURL: repo.localURL)
            repoTraits = analyzer.repoTraits
        }
        
        if repoTraits.containsReadMe {
            rows.append(Row(text: "ReadMe", imageName: "readme_icon", rightText: nil))
        }
        if repoTraits.containsGitignore {
            rows.append(Row(text: "Gitignore", imageName: "gitignore_icon", rightText: nil))
        }
        if repoTraits.containsLicense {
            rows.append(Row(text: "License", imageName: "license_icon", rightText: nil))
        }
        if repoTraits.containsTravis {
            rows.append(Row(text: "Travis", imageName: "travis_icon", rightText: nil))
        }
        if repoTraits.containsSwiftPackage {
            rows.append(Row(text: "Swift package", imageName: "spm_icon", rightText: nil))
        }
        
        for file in repoTraits.generalFiles {
            rows.append(Row(text: file.name, imageName: nil, rightText: String(file.linesCount)))
        }
    }
}
