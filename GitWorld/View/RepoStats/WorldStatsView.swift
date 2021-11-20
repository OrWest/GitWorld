//
//  WorldStatsView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 20.11.21.
//

import SwiftUI

struct WorldStatsView: View {
    var viewModel: WorldStatsViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.rows) { row in
                        StatRowView(row: row)
                    }
                } header: {
                    Text(section.title)
                        .foregroundColor(section.color)
                }

            }
        }
    }
}

struct WorldStatsView_Previews: PreviewProvider {
    static var previews: some View {
        WorldStatsView(viewModel: WorldStatsViewModel(world: AppContext.stub.world))
    }
}
