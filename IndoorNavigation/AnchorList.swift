//
//  AnchorList.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/30.
//

import ARKit
import RealityKit

class AnchorList {
    private var anchors: [ARAnchor] = []
    public let anchorName: String
    public let model: AssetModel
    
    init (anchorName: String, model: AssetModel) {
        self.anchorName = anchorName
        self.model = model
    }
    
    func reset() {
        anchors = []
    }
    
    func isEmpty() -> Bool {
        return anchors.count == 0
    }
    
    func genAnchor(transform: simd_float4x4) -> ARAnchor {
        let anchor = ARAnchor(
            name: anchorName,
            transform: transform
        )
        anchors.append(anchor)
        return anchor
    }
    
    func genAnchorEntity(anchor: ARAnchor) -> AnchorEntity? {
        if let modelEntity = self.model.modelEntity?.clone(recursive: true) {
            let anchorEntity = AnchorEntity(anchor: anchor)
            anchorEntity.name = self.anchorName
            anchorEntity.addChild(modelEntity)
            return anchorEntity
        } else {
            print("DEBUG: Unable to load modelEntity")
            return nil
        }
    }
    
    func getAnchors() -> [ARAnchor] {
        return anchors
    }
    
    func addAnchor(anchor: ARAnchor) {
        self.anchors.append(anchor)
    }
}
