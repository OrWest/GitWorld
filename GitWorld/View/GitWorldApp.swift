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
    @State private var context: AppContext? = AppContext()
    

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
    @AppStorage(AppStorageKey.worldMap) private var worldMapData: Data?

    private(set) var world: World!
    private(set) var repo: Repo!
    private(set) var analyzer: RepoAnalyzer!
    private(set) var worldMap: WorldMap!
    
    init?() {
        guard let urlString = gitURLInSettings,
                let url = URL(string: urlString),
                let repo = Repo(gitURL: url),
                let world = worldData.map ({ try! JSONDecoder().decode(World.self, from: $0) }),
                let worldMap = worldMapData.map ({ try! JSONDecoder().decode(WorldMap.self, from: $0) }),
                let analyzer = analyzerData.map ({ try! JSONDecoder().decode(RepoAnalyzer.self, from: $0) }) else { return nil }
        
        self.repo = repo
        self.world = world
        self.analyzer = analyzer
        self.worldMap = worldMap
    }
    
    init(repo: Repo, world: World, worldMap: WorldMap, analyzer: RepoAnalyzer, localOnly: Bool = false) {
        self.repo = repo
        self.world = world
        self.analyzer = analyzer
        self.worldMap = worldMap
        
        if !localOnly {
            // Save to reuse it from UD
            worldData = try! JSONEncoder().encode(world)
            analyzerData = try! JSONEncoder().encode(analyzer)
            worldMapData = try! JSONEncoder().encode(worldMap)
        }
    }
    
    func clean() {
        worldData = nil
        worldMapData = nil
    }
}

extension AppContext {
    static let stub = AppContext(repo: Repo(url: URL(string: "https://google.com/")!), world: World(name: "WORLD nAmE"), worldMap: WorldMap(world: World(name: "123")), analyzer: RepoAnalyzer(repoTraits: .stub), localOnly: true)
}
