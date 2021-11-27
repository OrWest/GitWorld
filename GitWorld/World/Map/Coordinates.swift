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
    
    static func -(lh: Coordinates, rh: Coordinates) -> Coordinates {
        return Coordinates(x: lh.x - rh.x,y: lh.y - rh.y)
    }
    
    func inverted() -> Coordinates {
        return Coordinates(x: x * -1, y: y * -1)
    }
    
    func distance(to coordinate: Coordinates) -> Int {
        let diff = self - coordinate
        
        let dSqrt = diff.x * diff.x + diff.y * diff.y
        let d = sqrt(Double(dSqrt)).rounded(.up)
        return Int(d)
    }
    
    static func random(in closedRange: ClosedRange<Int>) -> Coordinates {
        return Coordinates(x: Int.random(in: closedRange), y: Int.random(in: closedRange))
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
