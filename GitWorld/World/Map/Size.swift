//
//  Size.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 11.12.21.
//

import Foundation

struct Size: Codable {
    static let zero = Size(width: 0, height: 0)
    
    let width: Int
    let height: Int
}
