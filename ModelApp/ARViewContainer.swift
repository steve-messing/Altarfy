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
	
	func makeUIView(context: Context) -> ARView {
	
		
		arView.scene.anchors.append(lightAnchor)
		lightAnchor.addChild(spotLight)
		
		arView.scene.anchors.append(anchor)
		config.planeDetection = [.horizontal]
		config.environmentTexturing = .automatic
		
		if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
			config.sceneReconstruction = .mesh
		}
		
		arView.session.run(config)
		
		return arView
		
	}
	
	func updateUIView(_ uiView: ARView, context: Self.Context) {
		
		if let model = self.selectedModel {
			
			if let modelEntity = model.modelEntity {
				
				modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
				
				arView.installGestures([.all], for: modelEntity)
				
				modelEntity.generateCollisionShapes(recursive: true)
				
				anchor.addChild(modelEntity) // bug: .clone(recursive: true) breaks the gestures!!
							
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

