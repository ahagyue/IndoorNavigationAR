//
//  ARNavigationView+Gesture.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/30.
//

import ARKit
import RealityKit
import ARNavigationKit
import SwiftUI

extension ARNavigationView {
    func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if isSessionRelocalizing() {
            return
        }
        
        guard let point = sender?.location(in: self),
              let hitTestResult = self.hitTest(
                point,
                types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane]
        ).first
        else { return }
        
        let landmarkAnchor = self.landmarkAnchors.genAnchor(transform: hitTestResult.worldTransform)
        self.session.add(anchor: landmarkAnchor)
    }
    
    func isSessionRelocalizing() -> Bool {
        return isRelocalizingMap && landmarkAnchors.isEmpty()
    }
}
