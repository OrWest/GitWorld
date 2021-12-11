//
//  WorldMap.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

struct WorldMapRow: Codable {
    let village: WorldMapVillage
    let positionInVillageMap: Coordinates
}

class WorldMap: Codable {
    private enum Constants {
        static let villagePlacingMinDistance = 3
        static let placingTryBeforeIncreasingDistance = 20
        static let rangeToGenerateCoordinate = 30
        static let stepToIncreaseRangeToGenerateCoordinate = 10
        static let mapSizePadding = 8
    }

    let world: World
    
    let villages: [WorldMapVillage]
    let map: [[WorldMapRow?]]
    let size: Size
    
    init(world: World) {
        self.world = world
        let villages = WorldMap.generateVillages(world: world)
        self.villages = villages
        
        let map = WorldMap.placeVillages(villages: villages)
        self.map = map
        
        self.size = Size(width: map[safe: 0]?.count ?? 0, height: map.count)
    }
    
    private static func generateVillages(world: World) -> [WorldMapVillage] {
        return world.villages.map { WorldMapVillage(village: $0) }
    }
    
    private static func placeVillages(villages: [WorldMapVillage]) -> [[WorldMapRow?]] {
        var villages = villages.shuffled()
        var positions = [Coordinates: WorldMapVillage]()
        
        guard !villages.isEmpty else { return [[]] }
        
        positions[.zero] = villages.removeFirst()
        
        for village in villages {
            let coordinates = generateSafeCoordinates(for: village, otherCoordinates: positions)
            positions[coordinates] = village
        }
        
        let sizeAndCenter = getSizeAndCenter(of: positions)
        let size = sizeAndCenter.0
        let mapCenter = sizeAndCenter.1
        
        var map = [[WorldMapRow?]](repeating: [WorldMapRow?](repeating: nil, count: size.x), count: size.y)
        
        for (villageCoordinate, village) in positions {
            let absoluteCoordinate = villageCoordinate + mapCenter
            let origin = absoluteCoordinate - village.center
            
            village.worldPosition = absoluteCoordinate
            
            for i in 0..<village.size.width {
                for j in 0..<village.size.height {
                    map[origin.y + j][origin.x + i] = WorldMapRow(village: village, positionInVillageMap: Coordinates(x: i, y: j))
                }
            }
        }
        
        return map
    }
    
    private static func getSizeAndCenter(of positions: [Coordinates: WorldMapVillage]) -> (Coordinates, Coordinates) {
        var minX = 0
        var minY = 0
        var maxX = 0
        var maxY = 0
        for (coord, village) in positions {
            let leftBottomCoordinates = coord - village.center
            let rightTopCoordinates = leftBottomCoordinates + Coordinates(x: village.size.width, y: village.size.height)
            
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
        
        // Shift center to start drawing with padding
        let center = Coordinates(x: minX, y: minY).inverted() + Coordinates(x: Constants.mapSizePadding, y: Constants.mapSizePadding)
        
        return (Coordinates(x: x, y: y), center)
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
            
            if tryIndex >= Constants.placingTryBeforeIncreasingDistance {
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
