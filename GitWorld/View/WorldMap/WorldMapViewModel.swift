//
//  WorldMapViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation
import SwiftUI

class WorldMapViewModel: ObservableObject {
    private var world: World { context.world! }
    private var repo: Repo { context.repo! }
    
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?
    
    var statsViewModel: StatsViewModel {
        StatsViewModel(repo: repo)
    }
    
    private var context: AppContext
    
    var title: String { world.name }
    
    init(context: AppContext) {
        self.context = context
    }
    
    func logout() {
        repo.deleteRepo()
        context.clean()
        gitURLInSettings = nil
    }
}
