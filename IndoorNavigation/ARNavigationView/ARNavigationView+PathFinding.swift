//
//  ARNavigation+PathFinding.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/30.
//

import ARNavigationKit
import ARKit
import RealityKit

extension ARNavigationView: ARNavigationKitDelegate {
    func findPath() {
        let cam = self.cameraTransform.translation
        let camSCN = SCNVector3(x: cam.x, y: cam.y, z: cam.z)
        
        let landmark = self.landmarkAnchors.getAnchors()[self.landmarkAnchors.getAnchors().count - 1]
        let landmarkTranslation = Transform(matrix: landmark.transform).translation
        let landmarkSCN = SCNVector3(
            x: landmarkTranslation.x,
            y: landmarkTranslation.y,
            z: landmarkTranslation.z)
        print("dwafdsaf")
        self.navigator.getObstacleGraphAndPathDebug(start: camSCN, end: landmarkSCN)
    }
    
    func getPathupdate(_ path: [vector_float3]?) {
        print("here")
        
        for anchor in self.scene.anchors {
            if anchor.name == "path" {
                self.scene.removeAnchor(anchor)
            }
        }
        
        path?.forEach { p in
            let pathAnchor = self.pathAnchors.genAnchor(transform: createTranslationMatrix(translation: p))
            self.session.add(anchor: pathAnchor)
        }
    }

    func updateDebugView(_ View: UIView) {
        print("update")
        self.debugView.debugView.addSubview(View)
    }
    
    func createTranslationMatrix(translation: vector_float3) -> simd_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.columns.3.x = translation.x
        matrix.columns.3.y = translation.y
        matrix.columns.3.z = translation.z
        return matrix
    }
}
