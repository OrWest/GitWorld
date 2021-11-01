//
//  StatsView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 30.10.21.
//

import SwiftUI

struct StatsView: View {
    let viewModel: StatsViewModel
    
    var body: some View {
        List(viewModel.rows, id: \.text) { StatRow(row: $0) }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(viewModel: StatsViewModel(traits: .stub))
    }
}
