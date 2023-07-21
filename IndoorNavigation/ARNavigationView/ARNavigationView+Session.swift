//
//  ARNavigationView+Session.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/30.
//

import Foundation
import RealityKit
import ARKit

extension ARNavigationView: ARSessionDelegate {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("did add anchor: \(anchors.count) anchors in total")
        
        var meshAnchors: [ARMeshAnchor] = []
        
        for anchor in anchors {
            if let meshAnchor = anchor as? ARMeshAnchor {
                meshAnchors.append(meshAnchor)
            } else {
                addAnchorEntityToScene(anchor: anchor)
            }
        }
        
        self.navigator.generatingMapFromMesh(meshAnchors)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            self.navigator.updateGroundPlane(planeAnchor)
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Enable Save button only when the mapping status is good and an object has been placed
        switch frame.worldMappingStatus {
        case .extending, .mapped:
            saveLoadState.saveButton.isEnabled = !landmarkAnchors.isEmpty()
            saveLoadState.pathButton.isEnabled = !landmarkAnchors.isEmpty()
        default:
            saveLoadState.saveButton.isEnabled = false
            saveLoadState.pathButton.isEnabled = false
        }
        arState.mappingStatus = """
        Mapping: \(frame.worldMappingStatus.description)
        Tracking: \(frame.camera.trackingState.description)
        """
    }

    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        arState.sessionInfoLabel = "Session was interrupted"
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        arState.sessionInfoLabel = "Session interruption ended"
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        arState.sessionInfoLabel = "Session failed: \(error.localizedDescription)"
        guard error is ARError else { return }

        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]

        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")

        DispatchQueue.main.async {
            print("ERROR: \(errorMessage)")
            print("TODO: show error as an alert.")
        }
    }

    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
}
