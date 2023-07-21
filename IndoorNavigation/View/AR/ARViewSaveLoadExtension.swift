//
//  ARViewSaveLoadExtension.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/22.
//

import RealityKit
import ARKit
import Foundation

extension ARView {
    func save(as mapSaveURL: URL) {
        self.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else { return }
            print(map.anchors.count)
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: mapSaveURL, options: [.atomic])
            } catch {
                print(error)
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
    func load(from mapLoadURL: URL) -> ARWorldMap? {
        do {
            let data = try Data(contentsOf: mapLoadURL)
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                else { fatalError("No ARWorldMap in archive.") }
            return worldMap
        } catch {
            print("no initial map")
            return nil
        }
    }
}
