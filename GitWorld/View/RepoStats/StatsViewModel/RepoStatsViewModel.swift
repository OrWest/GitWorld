//
//  RepoStatsViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import Foundation

class RepoStatsViewModel: StatsViewModel {
    struct Row: StatRow {
        let text: String
        let imageName: String?
        let rightText: String?
    }
    
    var rows: [StatRow] = []
    
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
            rows.append(Row(text: file.name, imageName: nil, rightText: String(file.linesCount)))
        }
        
        return rows
    }
}
