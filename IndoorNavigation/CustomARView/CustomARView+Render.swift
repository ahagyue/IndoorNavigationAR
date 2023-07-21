//
//  CustomARView+Render.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import Foundation
import RealityKit
import ARKit

extension CustomARView {
    
    func addAnchorEntityToScene(anchor: ARAnchor) {
        guard anchor.name == virtualObjectAnchorName else {
            return
        }
        
        virtualObjectAnchors.append(anchor)
            
        if let modelEntity = virtualObject.modelEntity?.clone(recursive: true) {
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.addChild(modelEntity)
            self.scene.addAnchor(anchorEntity)
        } else {
            print("DEBUG: Unable to load modelEntity for \(virtualObject.name)")
        }
    }
    
}
