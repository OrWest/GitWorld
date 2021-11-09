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
    private let context = AppContext()
    

    var body: some Scene {
        WindowGroup {
//            DataBaseTableView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            if gitURLInSettings == nil {
                RepoSetView(viewModel: RepoSetViewModel(context: context))
            } else {
                WorldMapView(viewModel: WorldMapViewModel(context: context))
            }
        }
    }
}

class AppContext {
    @AppStorage(AppStorageKey.world) private var worldData: Data?
    @AppStorage(AppStorageKey.gitURL) private var gitURLInSettings: String?

    lazy var world: World? = worldData.map { try! JSONDecoder().decode(World.self, from: $0) } {
        didSet {
            if let world = world {
                worldData = try! JSONEncoder().encode(world)
            } else {
                worldData = nil
            }
        }
    }
    lazy var repo: Repo? = gitURLInSettings.map { Repo(gitURL: URL(string: $0)!)! }
    
    func clean() {
        world = nil
        repo = nil
    }
}
