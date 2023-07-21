//
//  ARViewContainer.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/22.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)
    var navigationPoints: [String: SIMD3<Float>] = [:]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        
        let world = arView.load(from: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("world") ?? URL(filePath: "world"))
//        
        print(world?.anchors.count)
        
        // Enable horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.initialWorldMap = world
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        
        init(_ arViewContainer: ARViewContainer) {
            self.parent = arViewContainer
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: parent.arView)
            
            if let raycastResult = parent.arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                do {
                    let anchor = ARAnchor(transform: raycastResult.worldTransform)
                    parent.arView.session.add(anchor: anchor)
//                    parent.arView.save(as: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("world") ?? URL(filePath: "world"))
                } catch {
                    print("error")
                }
            }
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            print(1)
            guard let imageAnchor = anchors.first else { return }

            let anchor = AnchorEntity(anchor: imageAnchor)
            
            do {
                print(2)
                let model = try Experience.loadBox()
                // Add Model Entity to anchor
                anchor.addChild(model)
                
                parent.arView.scene.anchors.append(anchor)
            } catch {
                print ("no Experience model")
            }
        }
    }
    
}
