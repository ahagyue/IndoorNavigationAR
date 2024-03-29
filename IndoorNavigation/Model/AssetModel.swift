//
//  AssetModel.swift
//  IndoorNavigation
//
//  Created by JMT on 2023/06/26.
//

import UIKit
import RealityKit
import Combine

class AssetModel {
    var name: String
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(name: String) {
        self.name = name
        
        self.cancellable = ModelEntity.loadModelAsync(named: name)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Unable to load a model due to error \(error)")
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                print("DEBUG: Successfully loaded modelEntity for modelName: \(name)")
            })
    }
}
