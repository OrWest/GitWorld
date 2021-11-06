//
//  VillageColorDistributor.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class VillageColorDistributor {
    private static let colorStep = 60
    
    private var availableColors: [VillageColor]
    private var usedColors: [String: VillageColor] = [:]
    
    init() {
        availableColors = VillageColorDistributor.generateColors()
    }
    
    func getColor(requesterId: String) -> VillageColor {
        if let existColor = usedColors[requesterId] {
            return existColor
        }
        
        guard !availableColors.isEmpty else {
            return VillageColor(r: 0, g: 0, b: 0)
        }
        
        let index = Int.random(in: 0..<availableColors.count)
        let color = availableColors.remove(at: index)
        usedColors[requesterId] = color
        
        return color
    }
    
    private static func generateColors() -> [VillageColor] {
        var colors: [VillageColor] = []
        
        // Black is used to error
        var r: Int = 0
        var g: Int = 0
        var b: Int = colorStep
            
        repeat {
            repeat {
                repeat {
                    colors.append(VillageColor(r: r, g: g, b: b))
                    b += colorStep
                } while b <= Int8.max
                g += colorStep
                b = 0
            } while g <= Int8.max
            r += colorStep
            g = 0
        } while r <= Int8.max
        
        return colors
    }
}
