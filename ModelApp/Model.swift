//
//  Model.swift
//  ModelApp
//
//  Created by Sophie Messing on 1/26/21.
//

import Foundation
import UIKit
import SwiftUI
import RealityKit
import Combine


class Model {
	
	var modelName: String
	var image: UIImage
	var modelEntity: ModelEntity?
	private var cancellable: AnyCancellable? = nil
	
	init(modelName: String) {
		
		self.modelName = modelName
		
//		self.image = UIImage(named: modelName)! // fix this later! to dynamically display image previews
		
		self.image = UIImage(named: "teapot")!
		
		let filename = modelName + ".usdz"
		
		self.cancellable = ModelEntity.loadModelAsync(named: filename)
			.sink(receiveCompletion: { loadCompletion in
				print("unable to load modelEntity for modelName \(self.modelName)")
			}, receiveValue: { modelEntity in
				self.modelEntity = modelEntity
				print("successfully loaded modelEntity for modelName \(self.modelName)")
			})
	}
}
