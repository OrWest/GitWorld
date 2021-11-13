//
//  WorldMapView.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import SwiftUI
import SpriteKit

struct WorldMapView: View {

    var viewModel: WorldMapViewModel
    
    var scene: SKScene = {
        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let scene = WorldMapScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return scene
    }()
        
    var body: some View {
        NavigationView {
            SpriteView(scene: scene)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
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
        WorldMapView(viewModel: WorldMapViewModel(context: .stub))
    }
}
