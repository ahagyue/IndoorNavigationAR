//
//  ARView.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/26.
//

import SwiftUI
import ARKit
import RealityKit

struct ARNavigationContainer: UIViewRepresentable {
    @EnvironmentObject var saveLoadState: SaveLoadState
    @EnvironmentObject var arState: ARState
    @EnvironmentObject var debugView: DebugView
    
    func makeUIView(context: Context) -> ARNavigationView {
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("ARKit is not available on this device")
        }
        
        let arView = ARNavigationView(
            frame: .zero,
            saveLoadState: saveLoadState,
            arState: arState,
            debugView: debugView
        )
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        return arView
    }
    
    func updateUIView(_ uiView: ARNavigationView, context: Context) {
        
        if saveLoadState.saveButton.isPressed {
            uiView.save(as: "test1")

            DispatchQueue.main.async {
                self.saveLoadState.saveButton.isPressed = false
            }
        }

        if saveLoadState.loadButton.isPressed {
            uiView.load(from: "test1")
            self.saveLoadState.loadButton.isPressed = false
            self.saveLoadState.pathButton.isPressed = false
        }
        
        if saveLoadState.pathButton.isPressed {
            uiView.findPath()
            self.saveLoadState.pathButton.isPressed = false
        }
    }

}
