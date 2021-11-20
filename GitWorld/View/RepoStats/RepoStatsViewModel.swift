//
//  RepoStatsViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import Foundation

class RepoStatsViewModel {
    struct Row: Identifiable, StatRow {
        let id: String
        let text: String
        let imageName: String?
        let rightText: String?
        let subTitle: String?
        
        init(id: String? = nil, text: String, imageName: String?, rightText: String?, subTitle: String? = nil) {
            self.id = id ?? text
            self.text = text
            self.imageName = imageName
            self.rightText = rightText
            self.subTitle = subTitle
        }
    }
    
    var rows: [Row] = []
    
    private let analyzer: RepoAnalyzer
    
    init(analyzer: RepoAnalyzer) {
        self.analyzer = analyzer
        rows = generateRows(repoTraits: analyzer.repoTraits)
    }
    
    private func generateRows(repoTraits: RepoTraits) -> [Row] {
        var rows: [Row] = []
        
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
            rows.append(Row(id: file.relativePath, text: file.name, imageName: nil, rightText: file.linesCount > 0 ? String(file.linesCount) : nil, subTitle: file.relativePath))
        }
        
        return rows
    }
}
