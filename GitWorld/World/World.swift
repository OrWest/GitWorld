//
//  World.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class World: Codable {
    let name: String
    var villages: [Village] = []
    
    init(name: String) {
        self.name = name
    }
}
