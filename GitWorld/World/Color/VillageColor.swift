//
//  VillageColor.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation


struct VillageColor: Identifiable, Codable {
    var id: Int {
        return Int(r)<<16 | Int(g) << 8 | Int(b)
    }
    
    let r: Int8
    let g: Int8
    let b: Int8
    
    init(r: Int, g: Int, b: Int) {
        self.r = Int8(r)
        self.g = Int8(g)
        self.b = Int8(b)
    }
}
