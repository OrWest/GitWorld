//
//  Village.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class Village: Codable {
    let name: String
    let color: VillageColor
    
    var houses: [House] = []
    
    init(name: String, color: VillageColor) {
        self.name = name
        self.color = color
    }
}
