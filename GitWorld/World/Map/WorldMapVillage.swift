//
//  WorldMapVillage.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMapVillage: Codable {    
    let village: Village
    let map: [[WorldMapHouse?]]
    let size: Size
    var worldPosition: Coordinates?
    var radius: Int {
        let r = Float(max(size.width, size.height)) / 2
        return Int(r.rounded(.up))
    }
    var center: Coordinates { Coordinates(x: size.width / 2, y: size.height / 2) }
    
    init(village: Village) {
        self.village = village
        
        let mapHouses = WorldMapVillage.generage(village: village)
        let map = WorldMapVillage.generateMap(houses: mapHouses)
        self.map = map

        if map.isEmpty {
            self.size = .zero
        } else {
            self.size = Size(width: map[0].count, height: map.count)
        }
    }
    
    private static func generage(village: Village) -> [WorldMapHouse] {
        var mapHouses: [WorldMapHouse] = []
        
        var houses = village.houses.shuffled().sorted { $0.size >= $1.size }
        
        if !houses.isEmpty {
            mapHouses.append(WorldMapHouse(house: houses.removeFirst(), coordinates: .zero))
        }
        
        for house in houses {
            var generated = false
            repeat {
                let randomMapHouse = mapHouses.randomElement()!
                let randomOffset = getRandomOffsetCoordinates()
                
                if !randomMapHouse.neighbour.contains(randomOffset) {
                    let newCoordinates = randomMapHouse.coordinates + randomOffset
                    
                    let newMapHouse = WorldMapHouse(house: house, coordinates: newCoordinates)
                    mapHouses.append(newMapHouse)
                    randomMapHouse.addNeighbour(newMapHouse, offset: randomOffset)
                    generated = true
                }
            } while !generated
        }
        
        return mapHouses
    }
    
    private static func generateMap(houses: [WorldMapHouse]) -> [[WorldMapHouse?]] {
        guard !houses.isEmpty else { return [] }
        
        let allCoordinates = houses.map { $0.coordinates }
        let minX = allCoordinates.min { $0.x <= $1.x }!.x
        let minY = allCoordinates.min { $0.y <= $1.y }!.y
        
        let maxX = allCoordinates.min { $0.x >= $1.x }!.x
        let maxY = allCoordinates.min { $0.y >= $1.y }!.y
        
        let coordinateCompensation = Coordinates(x: minX, y: minY).inverted()
        
        // Add (1, 1) because (0,0) position should be generated
        let size = Coordinates(x: maxX, y: maxY) + coordinateCompensation + Coordinates(x: 1, y: 1)
        
        // Fill 2d array with nils
        var map = [[WorldMapHouse?]](repeating: [WorldMapHouse?](repeating: nil, count: size.x), count: size.y)
        
        for house in houses {
            let coordinate = house.coordinates + coordinateCompensation
            map[coordinate.y][coordinate.x] = house
        }
        
        return map
    }
    
    
    // Generate random offset from center, except (0,0) position
    private static func getRandomOffsetCoordinates() -> Coordinates {
        let x = Int.random(in: -1...1)
        let y = Int.random(in: -1...1)
        
        // For 0,0 regenerate it
        if x == 0 && y == 0 {
            return getRandomOffsetCoordinates()
        }
        
        return Coordinates(x: x, y: y)
    }
}
