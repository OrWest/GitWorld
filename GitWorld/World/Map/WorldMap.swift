//
//  WorldMap.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMap {
    private static let villagePlacingMinDistance = 10
    private static let placingTryBeforeIncreasingDisance = 20
    private static let rangeToGenerateCoordinate = 100
    private static let stepToIncreaseRangeToGenerateCoordinate = 100
    
    let world: World
    
    let villages: [WorldMapVillage]
    let map: [[WorldMapVillage?]]
    
    init(world: World) {
        self.world = world
        let villages = WorldMap.generateVillages(world: world)
        self.villages = villages
        self.map = WorldMap.placeVillages(villages: villages)
    }
    
    private static func generateVillages(world: World) -> [WorldMapVillage] {
        return world.villages.map { WorldMapVillage(village: $0) }
    }
    
    private static func placeVillages(villages: [WorldMapVillage]) -> [[WorldMapVillage?]] {
        var villages = villages.shuffled()
        var positions = [Coordinates: WorldMapVillage]()
        
        guard !villages.isEmpty else { return [[]] }
        
        positions[.zero] = villages.removeFirst()
        
        for village in villages {
            let coordinates = generateSafeCoordinates(for: village, otherCoordinates: positions)
            positions[coordinates] = village
        }
        
        //let size
        //var map = [[WorldMapVillage?]]()
        // village position - center -> fill for size
        
        fatalError()
    }
    
    private static func generateSafeCoordinates(for village: WorldMapVillage, otherCoordinates: [Coordinates: WorldMapVillage]) -> Coordinates {
        var coordinates: Coordinates?
        var range = rangeToGenerateCoordinate
        var tryIndex = 0
        repeat {
            let randomCoordinate = Coordinates.random(in: -range...range)
            if isCoordinatesSafe(randomCoordinate, village: village, coordinates: otherCoordinates) {
                coordinates = randomCoordinate
            } else {
                tryIndex += 1
            }
            
            if tryIndex >= placingTryBeforeIncreasingDisance {
                tryIndex = 0
                range += stepToIncreaseRangeToGenerateCoordinate
            }
            
        } while coordinates == nil
        
        return coordinates!
    }
    
    private static func isCoordinatesSafe(_ coord: Coordinates, village: WorldMapVillage, coordinates: [Coordinates: WorldMapVillage]) -> Bool {
        
        let v1r = village.radius
        for (coord2, village2) in coordinates {
            let v2r = village2.radius
            let minDistance = v1r + v2r + villagePlacingMinDistance
            let distance = coord.distance(to: coord2)
            
            if distance < minDistance {
                return false
            }
        }
        
        return true
    }
}
