//
//  WorldMapView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import SwiftUI

struct WorldMapView: View {
    var viewModel: WorldMapViewModel
    
    var body: some View {
        NavigationView {
            Text("Map")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: StatsView(viewModel: viewModel.statsViewModel)) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.logout()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
        }
    }
}

struct WorldMapView_Previews: PreviewProvider {
    static var previews: some View {
        WorldMapView(viewModel: WorldMapViewModel(context: AppContext()))
    }
}
