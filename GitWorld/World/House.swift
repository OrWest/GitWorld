//
//  House.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class House: Codable {
    let id: String
    let name: String
    let size: Int
    
    init(id: String, name: String, size: Int) {
        self.id = id
        self.name = name
        self.size = size
    }
}
