//
//  Coordinates.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 21.11.21.
//

import Foundation

struct Coordinates {
    let x: Int
    let y: Int
}

extension Coordinates {
    static let zero = Coordinates(x: 0, y: 0)
    
    static func +(lh: Coordinates, rh: Coordinates) -> Coordinates {
        return Coordinates(x: lh.x + rh.x,y: lh.y + rh.y)
    }
    
    func inverted() -> Coordinates {
        return Coordinates(x: x * -1, y: y * -1)
    }
}

extension Coordinates: Comparable {
    static func < (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.x < rhs.x &&
                lhs.y < rhs.y
    }
    
    static func >= (lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.x >= rhs.x &&
                lhs.y >= rhs.y
    }
}

extension Coordinates: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
