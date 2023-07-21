//
//  ARNavigation+Render.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/29.
//

import ARKit
import RealityKit

extension ARNavigationView {
    
    func addAnchorEntityToScene(anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            self.navigator.updateGroundPlane(planeAnchor)
        }
        
        if anchor.name == self.landmarkAnchors.anchorName {
            addEntity(container: self.landmarkAnchors, anchor: anchor)
        }
        
        if anchor.name == self.pathAnchors.anchorName {
            addEntity(container: self.pathAnchors, anchor: anchor)
        }
    }
    
    func addEntity(container: AnchorList, anchor:ARAnchor) {
        guard let anchorEntity = container.genAnchorEntity(anchor: anchor) else {return}
        self.scene.addAnchor(anchorEntity)
    }
    
}
