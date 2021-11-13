//
//  WorldMapScene.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 13.11.21.
//

import SpriteKit

class WorldMapScene: SKScene {
    override func didMove(to view: SKView) {
        let node = SKShapeNode(rect: CGRect(x: -10, y: 10, width: 20, height: 20))
        node.fillColor = .red
        node.position = .zero
        
        addChild(node)
    }
}
