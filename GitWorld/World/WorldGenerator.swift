//
//  WorldGenerator.swift
//  GitWorld
//
//  Created by Aleksandr Motarykin on 6.11.21.
//

import Foundation

class WorldGenerator {
    private let colorDistributor = VillageColorDistributor()
    private let builder: WorldBuilder
    
    init(name: String) {
        builder = WorldBuilder(worldName: name)
    }
    
    func generate(repoTraits: RepoTraits) async -> World {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let world = self.generate(repoTraits: repoTraits)
                continuation.resume(returning: world)
            }
        }
    }
    
    func generate(repoTraits: RepoTraits) -> World {
        let groups = groupFilesByExtension(files: repoTraits.generalFiles)
        
        for group in groups {
            let groupName = group.key
            builder.addVillage(name: groupName, color: colorDistributor.getColor(requesterId: groupName))
            
            for file in group.value {
                builder.addHous(file: file)
            }
        }
        
        return builder.build()
    }
    
    private func groupFilesByExtension(files: [RepoFile]) -> [String: [RepoFile]] {
        var groups: [String: [RepoFile]] = [:]
        
        for file in files {
            let lowerCasedName = file.name.lowercased()
            let components = lowerCasedName.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
            let ext = String(components[safe: 1] ?? "")
            
            var group = groups[ext] ?? []
            group.append(file)
            groups[ext] = group
        }
        
        return groups
    }
}
