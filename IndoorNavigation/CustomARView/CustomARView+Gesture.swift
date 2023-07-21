//
//  CustomARView+Gesture.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//

import SwiftUI
import ARKit

extension CustomARView {

    func setupGestures() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
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
        
        let virtualObjectAnchor = ARAnchor(
            name: virtualObjectAnchorName,
            transform: hitTestResult.worldTransform
        )
        
        self.session.add(anchor: virtualObjectAnchor)
    }
    
    
    func isSessionRelocalizing() -> Bool {
        return isRelocalizingMap && virtualObjectAnchors == []
    }
}
