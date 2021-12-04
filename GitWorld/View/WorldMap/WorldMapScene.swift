//
//  WorldMapScene.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 13.11.21.
//

import SpriteKit

class WorldMapScene: SKScene {
    private let spriteSize = CGSize(width: 30, height: 30)
    
    var worldMap: WorldMap!
    private var cameraNode = SKCameraNode()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        camera = cameraNode
    }
    
    func drawMap() {
        guard let worldMap = worldMap, !worldMap.map.isEmpty else {
            removeAllChildren()
            return
        }
        
        let map = worldMap.map
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                let origin = CGPoint(x: CGFloat(x) * spriteSize.width, y: CGFloat(y) * spriteSize.height)
                let node = SKShapeNode(rect: CGRect(origin: origin, size: spriteSize))
                node.fillColor = map[y][x] == nil ? .green : .red
                node.position = .init(x: -1, y: -1)
                addChild(node)
            }
        }
        
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)

        camera?.position.x += previousLocation.x - location.x
        camera?.position.y += previousLocation.y - location.y
      }
}
