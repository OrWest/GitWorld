//
//  GitWorldApp.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 31.10.21.
//

import SwiftUI

@main
struct GitWorldApp: App {
    @AppStorage(AppStorageKey.gitURL) private var gitURLInSettings: String?

    private let persistenceController = PersistenceController.shared
    @State private var context: AppContext?
    

    var body: some Scene {
        WindowGroup {
//            DataBaseTableView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            if gitURLInSettings != nil, let context = context {
                WorldMapView(viewModel: WorldMapViewModel(context: context))
            } else {
                RepoSetView(viewModel: RepoSetViewModel(context: $context))
            }
        }
    }
}

class AppContext {
    @AppStorage(AppStorageKey.world) private var worldData: Data?
    @AppStorage(AppStorageKey.gitURL) private var gitURLInSettings: String?
    @AppStorage(AppStorageKey.analyzer) private var analyzerData: Data?

    private(set) var world: World!
    private(set) var repo: Repo!
    private(set) var analyzer: RepoAnalyzer!
    
    init?() {
        guard let repo = gitURLInSettings.map({ Repo(gitURL: URL(string: $0)!)! }),
              let world = worldData.map ({ try! JSONDecoder().decode(World.self, from: $0) }),
              let analyzer = analyzerData.map ({ try! JSONDecoder().decode(RepoAnalyzer.self, from: $0) }) else { return nil }
        
        self.repo = repo
        self.world = world
        self.analyzer = analyzer
    }
    
    init(repo: Repo, world: World, analyzer: RepoAnalyzer) {
        self.repo = repo
        self.world = world
        self.analyzer = analyzer
        
        // Save to reuse it from UD
        worldData = try! JSONEncoder().encode(world)
        analyzerData = try! JSONEncoder().encode(analyzer)
    }
    
    func clean() {
        worldData = nil
    }
}

extension AppContext {
    static let stub = AppContext(repo: Repo(gitURL: URL(string: "https://google.com")!)!, world: World(name: "WORLD nAmE"), analyzer: RepoAnalyzer(repoTraits: .stub))
}
