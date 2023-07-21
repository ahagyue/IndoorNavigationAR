//
//  Button.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/26.
//

import SwiftUI

struct ButtonContainer: View {
    @EnvironmentObject var saveLoadState: SaveLoadState
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // save button
                Button {
                    saveLoadState.saveButton.isPressed = true
                } label: {
                    Text("save map")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                }
                .background(saveLoadState.saveButton.isEnabled ? Color.blue : Color.gray)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!saveLoadState.saveButton.isEnabled)
                
                // load button
                Button {
                    saveLoadState.loadButton.isPressed = true
                } label: {
                    Text("load map")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                }
                .background(Color.blue)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!saveLoadState.loadButton.isEnabled)
                
                // path finding button
                Button {
                    saveLoadState.pathButton.isPressed = true
                } label: {
                    Text("path finding")
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                }
                .background(saveLoadState.pathButton.isEnabled ? Color.blue : Color.gray)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!saveLoadState.pathButton.isEnabled)
            }
        }
    }
}

struct ButtonContainer_Previews: PreviewProvider {
    static var previews: some View {
        ButtonContainer()
    }
}
