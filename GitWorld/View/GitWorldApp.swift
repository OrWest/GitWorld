//
//  GitWorldApp.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 31.10.21.
//

import SwiftUI

@main
struct GitWorldApp: App {
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?

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
    var world: World?
    var repo: Repo?
    
    func clean() {
        world = nil
        repo = nil
    }
}
