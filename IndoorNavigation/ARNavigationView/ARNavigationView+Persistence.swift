//
//  ARNavigationView+Persistence.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/30.
//

import ARKit
import ARNavigationKit

extension ARNavigationView {
    func load(from name: String) {
        let worldMapKey = getWorldMapKey(name)
        let navigatorKey = getNavigationKey(name)
        
        // loading world map
        let worldMap: ARWorldMap = loadWorld(from: worldMapKey)
        setConfig()
        self.configuration.initialWorldMap = worldMap
        self.session.run(self.configuration, options: [.resetTracking, .removeExistingAnchors])
        
        self.session.currentFrame?.anchors.forEach { anchor in
            self.landmarkAnchors.addAnchor(anchor: anchor)
        }
        
        // loading navigator data
        guard let navigatorData: Data = UserDefaults.standard.data(forKey: navigatorKey) else { return }
        self.navigator = ARNavigationKit(data: navigatorData, 0.07)
    }
    
    func save(as name: String) {
        let worldMapKey = getWorldMapKey(name)
        let navigatorKey = getNavigationKey(name)
        
        // erase without landmark
        self.session.currentFrame?.anchors.reversed().forEach { anchor in
            if anchor.name != self.landmarkAnchors.anchorName {
                self.session.remove(anchor: anchor)
            }
        }
        
        // saving world map
        self.session.getCurrentWorldMap { worldMap, _ in
            self.saveWorld(worldMap: worldMap, as: worldMapKey)
        }
        
        // saving navigator data
        let navigatorData = self.navigator.getMapData()
        UserDefaults.standard.set(navigatorData, forKey: navigatorKey)
    }
    
    // MARK: Loading and Saving World
    
    func loadWorld(from worldMapKey: String) -> ARWorldMap {
        guard let data = UserDefaults.standard.data(forKey: worldMapKey)
            else {
            fatalError("Map data should already be verified to exist before Load button is enabled.")
        }
        do {
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                else { fatalError("No ARWorldMap in archive.") }
            return worldMap
        } catch {
            fatalError("Can't unarchive ARWorldMap from file data: \(error)")
        }
    }
    
    func saveWorld(worldMap: ARWorldMap?, as worldMapKey: String) {
        guard let map = worldMap else {
            self.arState.sessionInfoLabel = "Can't get current world map"
            return
        }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
            UserDefaults.standard.set(data, forKey: worldMapKey)
            DispatchQueue.main.async {
                self.saveLoadState.loadButton.isEnabled = true
            }
        } catch {
            fatalError("Can't save map: \(error.localizedDescription)")
        }
    }
    
    // MARK: Get Key
    
    func getWorldMapKey(_ name: String) -> String {
        return "map.\(name)"
    }
    
    func getNavigationKey(_ name: String) -> String {
        return "navigation.\(name)"
    }
}
