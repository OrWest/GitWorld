//
//  WorldMapScene.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 13.11.21.
//

import SpriteKit

class WorldMapScene: SKScene {
    private let spriteSize = CGSize(width: 5, height: 5)
    private let maxScale: CGFloat = 4.0
    
    var worldMap: WorldMap!
    private var cameraNode = SKCameraNode()
    private var previousCameraScale: CGFloat = 1.0
    private var panBeginPosition: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        camera = cameraNode
        
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)
        
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)                
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
                node.strokeColor = .clear
                addChild(node)
            }
        }
        
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    @objc private func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began, let scale = camera?.xScale {
            previousCameraScale = scale
        }
        
        let newScale = min(previousCameraScale / sender.scale, maxScale)
        camera?.setScale(newScale)
    }
    
    @objc private func panGestureAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began, let beginPosition = camera?.position {
            panBeginPosition = beginPosition
        }
    
        var translationPoint = sender.translation(in: nil)
        let scale = camera?.xScale ?? 1.0
        
        // With scale translation should be adjusted
        translationPoint = CGPoint(x: translationPoint.x * scale, y: translationPoint.y * scale)
        
        // Invert, because SpriteKit coordinate systems zero is in left bottom but iOS native coords is in top left
        translationPoint.y = -translationPoint.y
        
        camera?.position = panBeginPosition - translationPoint
    }
}

extension WorldMapScene: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

private extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
