//
//  WorldMap.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMap {
    let world: World
    
    let villages: [WorldMapVillage]
    
    init(world: World) {
        self.world = world
        self.villages = WorldMap.generateVillages(world: world)
    }
    
    private static func generateVillages(world: World) -> [WorldMapVillage] {
        return world.villages.map { WorldMapVillage(village: $0) }
    }
}
