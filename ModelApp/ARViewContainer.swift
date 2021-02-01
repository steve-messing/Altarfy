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


struct ARViewContainer: UIViewRepresentable {
	
	typealias UIViewType = ARView
	
	@Binding var selectedModel: Model?
	
	let arView = ARView(frame: .zero)
	let anchor = try! Experience.loadBox()
	let config = ARWorldTrackingConfiguration()
	
	func makeUIView(context: Context) -> ARView {
		
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
			}
			
			DispatchQueue.main.async {
				self.selectedModel = nil
			}
		}
	}
}
