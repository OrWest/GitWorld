//
//  WorldMapHouse.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMapHouse: Codable {
    let house: House
    let coordinates: Coordinates
    private(set) var neighbour: Set<Coordinates> = []
    
    init(house: House, coordinates: Coordinates) {
        self.house = house
        self.coordinates = coordinates
    }
    
    func addNeighbour(_ house: WorldMapHouse, offset: Coordinates) {
        neighbour.insert(offset)
        house.neighbour.insert(offset.inverted())
    }
}
