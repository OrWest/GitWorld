//
//  WorldMapViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation
import SwiftUI

class WorldMapViewModel {
    private let world: World
    private let repo: Repo
    
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?
    
    var statsViewModel: StatsViewModel {
        StatsViewModel(repo: repo)
    }
    
    init(repo: Repo) {
        self.repo = repo
        
        let worldName = repo.localURL.deletingPathExtension().lastPathComponent
        
        if !repo.cloned {
            do {
                //try repo.cloneRepo()
            } catch {
                world = World(name: worldName)
                Logger.log("[StatsViewModel] Clone failed. Pending state.")
                return
            }
        }
        
        let analyzer = RepoAnalyzer(localURL: repo.localURL)
        
        let worldGenerator = WorldGenerator(name: worldName)
        self.world = worldGenerator.generate(repoTraits: analyzer.repoTraits)
        print(world)
    }
    
    func logout() {
        repo.deleteRepo()
        gitURLInSettings = nil
    }
}
