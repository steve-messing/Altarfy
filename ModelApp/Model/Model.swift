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
import QuickLookThumbnailing


class Model {
	
	var modelName: String
	var image: UIImage
	var modelEntity: ModelEntity?
//	var anchorEntity: AnchorEntity?
	var scaleCompensation: Float
	private var cancellable: AnyCancellable? = nil
	
	init(modelName: String, scaleCompensation: Float = 1.0) {
		
		self.modelName = modelName
		let filename = modelName + ".usdz"
		self.scaleCompensation = scaleCompensation	
		self.image = UIImage(named: modelName) ?? UIImage(systemName: "photo")!
		
		self.cancellable = ModelEntity.loadModelAsync(named: filename)
			.sink(receiveCompletion: { loadCompletion in
				// print("unable to load modelEntity for modelName \(self.modelName)")
			}, receiveValue: { modelEntity in
				self.modelEntity = modelEntity
				print("successfully loaded modelEntity for modelName \(self.modelName)")
			})
	}
}
