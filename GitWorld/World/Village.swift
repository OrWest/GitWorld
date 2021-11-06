//
//  Village.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

struct VillageColor {
    let r: Int8
    let g: Int8
    let b: Int8
}

class Village {
    let name: String
    let color: VillageColor
    
    var houses: [House] = []
    
    init(name: String, color: VillageColor) {
        self.name = name
        self.color = color
    }
}
