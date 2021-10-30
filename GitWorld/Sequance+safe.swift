//
//  Array+safe.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.count > index else { return nil }
        
        return self[index]
    }
}
