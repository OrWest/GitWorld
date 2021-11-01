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

    var body: some Scene {
        WindowGroup {
//            DataBaseTableView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            if gitURLInSettings == nil {
                RepoSetView(viewModel: RepoSetViewModel())
            } else {
                StatsView(viewModel: StatsViewModel())
            }
        }
    }
}
