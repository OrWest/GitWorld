//
//  WorldMapViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation
import SwiftUI

class WorldMapViewModel: ObservableObject {
    private var world: World { context.world }
    private var repo: Repo { context.repo }
    
    @AppStorage(AppStorageKey.gitURL) var gitURLInSettings: String?
    
    let context: AppContext
    
    var title: String { world.name }
    
    init(context: AppContext) {
        self.context = context
    }
    
    func logout() {
        repo.deleteRepoIfExist()
        context.clean()
        gitURLInSettings = nil
    }
}
