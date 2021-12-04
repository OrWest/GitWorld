//
//  WorldMap.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

class WorldMap {
    private enum Constants {
        static let villagePlacingMinDistance = 10
        static let placingTryBeforeIncreasingDisance = 20
        static let rangeToGenerateCoordinate = 100
        static let stepToIncreaseRangeToGenerateCoordinate = 100
        static let mapSizePadding = 20
    }

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
        
        
        let size = getSize(of: positions)
        
        var map = [[WorldMapVillage?]](repeating: [WorldMapVillage?](repeating: nil, count: size.x), count: size.y)
        let mapCenter = Coordinates(x: size.x / 2 + 1, y: size.y / 2 + 1)
        
        for (villageCoordinate, village) in positions {
            let absoluteCoordinate = villageCoordinate + mapCenter
            let origin = absoluteCoordinate - village.center
            
            for i in 0..<village.size.0 {
                for j in 0..<village.size.1 {
                    map[origin.y + j][origin.x + i] = village
                }
            }
        }
        
        return map
    }
    
    private static func getSize(of positions: [Coordinates: WorldMapVillage]) -> Coordinates {
        var minX = 0
        var minY = 0
        var maxX = 0
        var maxY = 0
        for (coord, village) in positions {
            let leftBottomCoordinates = coord - village.center
            let rightTopCoordinates = leftBottomCoordinates + Coordinates(x: village.size.0, y: village.size.1)
            
            minX = min(minX, leftBottomCoordinates.x)
            minY = min(minY, leftBottomCoordinates.y)
            maxX = max(maxX, rightTopCoordinates.x)
            maxY = max(maxY, rightTopCoordinates.y)
        }
        
        var x = maxX - minX + Constants.mapSizePadding * 2
        var y = maxY - minY + Constants.mapSizePadding * 2
        
        // To have simetryc world like -10 12 rather then -10 9
        if x % 2 == 0 { x += 1 }
        if y % 2 == 0 { y += 1 }
        
        return Coordinates(x: x, y: y)
    }
    
    private static func generateSafeCoordinates(for village: WorldMapVillage, otherCoordinates: [Coordinates: WorldMapVillage]) -> Coordinates {
        var coordinates: Coordinates?
        var range = Constants.rangeToGenerateCoordinate
        var tryIndex = 0
        repeat {
            let randomCoordinate = Coordinates.random(in: -range...range)
            if isCoordinatesSafe(randomCoordinate, village: village, coordinates: otherCoordinates) {
                coordinates = randomCoordinate
            } else {
                tryIndex += 1
            }
            
            if tryIndex >= Constants.placingTryBeforeIncreasingDisance {
                tryIndex = 0
                range += Constants.stepToIncreaseRangeToGenerateCoordinate
            }
            
        } while coordinates == nil
        
        return coordinates!
    }
    
    private static func isCoordinatesSafe(_ coord: Coordinates, village: WorldMapVillage, coordinates: [Coordinates: WorldMapVillage]) -> Bool {
        
        let v1r = village.radius
        for (coord2, village2) in coordinates {
            let v2r = village2.radius
            let minDistance = v1r + v2r + Constants.villagePlacingMinDistance
            let distance = coord.distance(to: coord2)
            
            if distance < minDistance {
                return false
            }
        }
        
        return true
    }
}
