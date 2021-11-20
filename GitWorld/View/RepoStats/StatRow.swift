//
//  StatRow.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 20.11.21.
//

import Foundation

protocol StatRow {
    var text: String { get }
    var subTitle: String? { get }
    var imageName: String? { get }
    var rightText: String? { get }
}
