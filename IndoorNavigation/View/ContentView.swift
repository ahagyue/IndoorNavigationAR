//
//  ContentView.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @EnvironmentObject var debugView: DebugView
    
    var body: some View {
        ZStack {
            VStack {
                ARNavigationContainer()
                    .edgesIgnoringSafeArea(.all)
                DebugViewContainer()
            }
            
            ButtonContainer()
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
