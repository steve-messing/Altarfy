//
//  ARViewContainer.swift
//  ModelApp
//
//  Created by Sophie Messing on 1/31/21.
//

import SwiftUI
import UIKit
import RealityKit
import ARKit


class DirectionalLighting: Entity, HasDirectionalLight {
	
	required init() {
		super.init()
		
		self.light = DirectionalLightComponent(color: .white,
											   intensity: 5000,
											   isRealWorldProxy: true)
		
		self.shadow = DirectionalLightComponent.Shadow(maximumDistance: 5,
													   depthBias: 2.5)
	}
}


class SpotLighting: Entity, HasSpotLight {
	
	required init() {
		super.init()
		
		self.light = SpotLightComponent(color: .white,
											   intensity: 20000,
											   innerAngleInDegrees: 70,
											   outerAngleInDegrees: 120,
											   attenuationRadius: 9.0)
		
		self.shadow = SpotLightComponent.Shadow()
		self.position.y = 1.2
	}
}



struct ARViewContainer: UIViewRepresentable {
	
	typealias UIViewType = ARView
	
	@Binding var selectedModel: Model?
	
	let arView = ARView(frame: .zero)
	let anchor = try! Experience.loadBox()
	let config = ARWorldTrackingConfiguration()
	
	let directionalLight = DirectionalLighting()
	let spotLight = SpotLighting()
	let lightAnchor = AnchorEntity()
	
	// tap gestures
	
	func makeUIView(context: Context) -> ARView {
		
		arView.scene.anchors.append(lightAnchor)
		lightAnchor.addChild(spotLight)
		
		
		arView.scene.anchors.append(anchor)
		config.planeDetection = [.horizontal]
		config.environmentTexturing = .automatic
		
		if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
			config.sceneReconstruction = .mesh
		}
		
		arView.enableObjectRemoval()
//		arView.enableObjectDuplicate()
		
		arView.session.run(config)
		
		return arView
		
	}
	
	func updateUIView(_ uiView: ARView, context: Self.Context) {
		
		if let model = self.selectedModel {
			
			if let modelEntity = model.modelEntity {
				
				modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
				
//				let anchorEntity = AnchorEntity()
//				modelEntity.setParent(anchorEntity)
				
				modelEntity.generateCollisionShapes(recursive: true)
				arView.installGestures(for: modelEntity)
				
				anchor.addChild(modelEntity)
				modelEntity.setPosition(SIMD3<Float>(0, 0.97, -0.3), relativeTo: anchor)
				
				var placedModels: [Model] = []
				placedModels.append(model)
				
				}
			}
					
			DispatchQueue.main.async {
				self.selectedModel = nil
			}
		}
	}

// long press duplicate
//extension ARView {
//
//	func enableObjectDuplicate() {
//		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
//
//		self.addGestureRecognizer(longPressGestureRecognizer)
//	}
//
//	@objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
//		let location = recognizer.location(in: self)
//
//		if let entity = self.entity(at: location) {
//			if let anchor = entity.anchor {
//				let clonedEntity = entity.clone(recursive: true)
//				anchor.addChild(clonedEntity)
//			}
//		}
//	}
//}

// double tap delete
extension ARView {
	
	func enableObjectRemoval() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
		
		tapGestureRecognizer.numberOfTapsRequired = 2
		
		self.addGestureRecognizer(tapGestureRecognizer)
	}
	
	@objc func handleTap(recognizer: UITapGestureRecognizer) {
		let location = recognizer.location(in: self)
		
		if let entity = self.entity(at: location) {
			entity.removeFromParent()
		}
	}
}


