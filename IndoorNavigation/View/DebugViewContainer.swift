//
//  DebugView.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/07/03.
//

import SwiftUI
import ARKit
import RealityKit

struct DebugViewContainer: UIViewRepresentable {
    @EnvironmentObject var debugView: DebugView
    
    func makeUIView(context: Context) -> UIView {
        return debugView.debugView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
