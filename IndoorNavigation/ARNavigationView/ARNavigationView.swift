//
//  ARNavigationView.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/29.
//

import ARKit
import RealityKit
import ARNavigationKit

class ARNavigationView: ARView{
    // Referring to @EnvironmentObject
    var saveLoadState: SaveLoadState
    var arState: ARState
    var debugView: DebugView
    
    var navigator = ARNavigationKit(VoxelGridCellSize: 0.07)
    let configuration = ARWorldTrackingConfiguration()
    
    var isRelocalizingMap = false
    
    var landmarkAnchors = AnchorList(anchorName: "landmark", model: AssetModel(name: "Flag.usdz"))
    var pathAnchors = AnchorList(anchorName: "path", model: AssetModel(name: "Path.usdz"))
    
    init(
        frame           : CGRect,
        saveLoadState   : SaveLoadState,
        arState         : ARState,
        debugView       : DebugView
    ) {
        self.saveLoadState = saveLoadState
        self.arState = arState
        self.debugView = debugView
        
        super.init(frame: frame)
        
        setConfig()
        setupGestures()
        setSceneView()
        
        setNavigator()
    }
    
    func setConfig() {
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
        } else {
            configuration.planeDetection = [.horizontal]
        }
        
        configuration.environmentTexturing = .automatic
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .meshWithClassification
        }
    }
    
    func setSceneView() {
        self.session.run(configuration)
        self.session.delegate = self
        self.debugOptions.insert(.showSceneUnderstanding)
    }
    
    func setNavigator() {
        self.navigator.arNavigationKitDelegate = self
        self.navigator.filter = .removeSingle
        self.navigator.noiseLevel = 5
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            guard let currentFrame = self.session.currentFrame,
                let featurePointsArray = currentFrame.rawFeaturePoints?.points else { return }
            self.navigator.addVoxels(featurePointsArray)
        }
    }
    
    func resetTracking() {
        setConfig()
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        self.isRelocalizingMap = false
        self.landmarkAnchors.reset()
    }
    
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor required dynamic init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
}
