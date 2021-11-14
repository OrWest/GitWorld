//
//  StatRow.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 14.11.21.
//

import Foundation

protocol StatRow {
    var text: String { get }
    var imageName: String? { get }
    var rightText: String? { get }
}
