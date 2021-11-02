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
            if let gitURLInSettings = gitURLInSettings, let url = URL(string: gitURLInSettings), let repo = Repo(gitURL: url) {
                StatsView(viewModel: StatsViewModel(repo: repo))
            } else {
                RepoSetView(viewModel: RepoSetViewModel())
            }
        }
    }
}
