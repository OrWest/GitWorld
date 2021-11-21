//
//  WorldMapHouse.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMapHouse {
    let house: House
    let coordinates: Coordinates
    private(set) var neighbour: [Coordinates: WorldMapHouse] = [:]
    
    init(house: House, coordinates: Coordinates) {
        self.house = house
        self.coordinates = coordinates
    }
    
    func addNeighbour(_ house: WorldMapHouse, offset: Coordinates) {
        neighbour[offset] = house
        house.neighbour[offset.inverted()] = self
    }
}
