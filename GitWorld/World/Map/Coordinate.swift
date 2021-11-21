//
//  Coordinates.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

struct Coordinates {
    static let zero = Coordinates(x: 0, y: 0)
    
    let x: Int
    let y: Int
    
    static func +(lh: Coordinates, rh: Coordinates) -> Coordinates {
        return Coordinates(x: lh.x + rh.x,y: lh.y + rh.y)
    }
}
