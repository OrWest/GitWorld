//
//  WorldBuilder.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class WorldBuilder {
    
    private let world: World
    private var currentVillage: Village?
    
    init(worldName: String) {
        world = World(name: worldName)
    }
    
    @discardableResult
    func addVillage(name: String, color: VillageColor) -> Self {
        if let currentVillage = currentVillage {
            world.villages.append(currentVillage)
        }
        
        currentVillage = Village(name: name, color: color)
        
        return self
    }
    
    @discardableResult
    func addHous(file: RepoFile) -> Self {
        currentVillage?.houses.append(House(name: file.name, size: file.linesCount))
        
        return self
    }
    
    func build() -> World {
        if let currentVillage = currentVillage {
            world.villages.append(currentVillage)
        }
        
        return world
    }
}
