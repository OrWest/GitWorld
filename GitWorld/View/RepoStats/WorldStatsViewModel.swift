//
//  WorldStatsViewModel.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 14.11.21.
//

import Foundation
import SwiftUI

class WorldStatsViewModel {
    struct Section: Identifiable {
        var id: String { title }
        let title: String
        let color: Color
        let rows: [Row]
    }
    
    struct Row: Identifiable, StatRow {
        let id: String
        let text: String
        let imageName: String?
        let rightText: String?
        var subTitle: String?
        
        init(id: String, text: String, imageName: String?, rightText: String?, subTitle: String?) {
            self.id = id
            self.text = text
            self.imageName = imageName
            self.rightText = rightText
            self.subTitle = subTitle
        }
        
        init(house: House) {
            self.init(id: house.id, text: house.name, imageName: nil, rightText: String(house.size), subTitle: house.id)
        }
    }
    
    private(set) var sections: [Section] = []
    
    private let world: World
    
    init(world: World) {
        self.world = world
        self.sections = generateSections(world: world)
    }
    
    private func generateSections(world: World) -> [Section] {
        var sections: [Section] = []
        
        for village in world.villages {
            var rows: [Row] = []
            
            for house in village.houses {
                rows.append(Row(house: house))
            }
            sections.append(Section(title: village.name, color: village.color.color, rows: rows))
        }
        
        return sections
    }
}

private extension VillageColor {
    var color: Color {
        return Color(
            red: Double(r)/Double(Int8.max),
            green: Double(g)/Double(Int8.max),
            blue: Double(b)/Double(Int8.max)
        )
    }
}
