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
    
    var scene: WorldMapScene = {
        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        let scene = WorldMapScene()
        scene.size = CGSize(width: screenWidth, height: screenHeight)
        scene.scaleMode = .fill
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        return scene
    }()
        
    var body: some View {
        NavigationView {
            SpriteView(scene: scene, options: [.shouldCullNonVisibleNodes], debugOptions: [.showsFPS, .showsNodeCount, .showsDrawCount])
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50) // to show fps
                .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: DebugView(context: viewModel.context)) {
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
        .onAppear {
            scene.worldMap = viewModel.worldMap
            scene.drawMap()
        }
    }
}

struct WorldMapView_Previews: PreviewProvider {
    static var previews: some View {
        WorldMapView(viewModel: WorldMapViewModel(context: .stub))
    }
}
