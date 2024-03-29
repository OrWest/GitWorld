//
//  WorldMapScene.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 13.11.21.
//

import SpriteKit

class WorldMapScene: SKScene {
    private let houseTileGroupName = "house"
    private let grassTileGroupName = "grass"
    private let yellowGrassTileGroupName = "yellow-grass"

    private let spriteSize = CGSize(width: 256, height: 256)
    private let minScale: CGFloat = 4.0
    private let defaultScale: CGFloat = 16.0
    private let villageNameLabelTopInset: CGFloat = 200
    
    var worldMap: WorldMap!
    private var cameraNode = SKCameraNode()
    private var tileMap: SKTileMapNode!
    private var previousCameraScale: CGFloat = 1.0
    private var panBeginPosition: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
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
        guard let worldMap = worldMap, !worldMap.map.isEmpty, let tileSet = SKTileSet(named: "Tile Set") else {
            removeAllChildren()
            return
        }
            
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: worldMap.size.width, rows: worldMap.size.height, tileSize: spriteSize)
        tileMap.fill(with: tileSet.tileGroups.first { $0.name == grassTileGroupName })
        tileMap.zPosition = -1
        self.tileMap = tileMap
        
<<<<<<< HEAD
        let houseGroup = tileSet.tileGroups.first { $0.name == houseTileGroupName }
        let grassGroup = tileSet.tileGroups.first { $0.name == grassTileGroupName }
        let yellowGrassGroup = tileSet.tileGroups.first { $0.name == yellowGrassTileGroupName }
        
=======
>>>>>>> 30de4b49776fc3df645f292f49e5f4811f18912f
        let map = worldMap.map
        for y in 0..<map.count {
            for x in 0..<map[y].count {
                guard let mapRow = map[y][x] else { continue }
                
                let position = tileMap.centerOfTile(atColumn: x, row: y)
                
<<<<<<< HEAD
                if let mapRow = map[y][x] {
                    if let _ = mapRow.village.map[mapRow.positionInVillageMap.y][mapRow.positionInVillageMap.x] {
                        tileGroup = houseGroup
                    } else {
                        tileGroup = yellowGrassGroup
                    }
=======
                if let _ = mapRow.village.map[mapRow.positionInVillageMap.y][mapRow.positionInVillageMap.x] {
                    let houseSprite = SKSpriteNode(imageNamed: "house")
                    
                    houseSprite.position = position
                    houseSprite.size = spriteSize
                    addChild(houseSprite)
>>>>>>> 30de4b49776fc3df645f292f49e5f4811f18912f
                } else {
                    let yellowNode = SKSpriteNode(color: .yellow.withAlphaComponent(0.5), size: spriteSize)
                    yellowNode.position = position

                    addChild(yellowNode)
                }
            }
        }
        
        addChild(tileMap)
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        cameraNode.setScale(defaultScale)
     
        addLabels()
    }
    
    private func addLabels() {
        for mapVillage in worldMap.villages {
            guard let worldVillageCenter = mapVillage.worldPosition else { continue }
            let labelNode = SKLabelNode()
            labelNode.fontSize = 200
            labelNode.fontName = UIFont.boldSystemFont(ofSize: 0).fontName
            labelNode.fontColor = .red
            labelNode.text = mapVillage.village.name
            
<<<<<<< HEAD
            let topCenterPosition = worldVillageCenter + Coordinates(x: 0, y: mapVillage.center.y * 2)
            let mapPosition = tileMap.centerOfTile(atColumn: topCenterPosition.y, row: topCenterPosition.x)
=======
            let topCenterPosition = worldVillageCenter + Coordinates(x: 0, y: mapVillage.center.y)
            let mapPosition = tileMap.centerOfTile(atColumn: topCenterPosition.x, row: topCenterPosition.y)
            
            // If village size is odd (2,4,6) center should be not tile center, but cross.
            let xCorrection = mapVillage.size.width % 2 == 0 ? spriteSize.width / 2 : 0
            let yCorrection = mapVillage.size.height % 2 == 0 ? spriteSize.height : 0
>>>>>>> 30de4b49776fc3df645f292f49e5f4811f18912f
            
            // Add distance to side (from center) and add top inset.
            let position = CGPoint(x: mapPosition.x - xCorrection, y: mapPosition.y + spriteSize.height / 2 + villageNameLabelTopInset - yCorrection)
            
            labelNode.position = position
            addChild(labelNode)
        }
    }
    
    @objc private func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began, let scale = camera?.xScale {
            previousCameraScale = scale
        }
        
        let newScale = max(previousCameraScale / sender.scale, minScale)
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

private extension Coordinates {
    func cgPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
