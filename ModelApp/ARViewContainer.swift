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


class SpotLighting: Entity, HasSpotLight {
	
	required init() {
		super.init()
		
		self.light = SpotLightComponent(color: .white,
											   intensity: 7000,
											   innerAngleInDegrees: 70,
											   outerAngleInDegrees: 120,
											   attenuationRadius: 9.0)
		
		self.shadow = SpotLightComponent.Shadow()
		self.position.y = 1.5
		self.position.z = 0.5
	}
}



struct ARViewContainer: UIViewRepresentable {
		
	let url: URL?
	
	@Binding var selectedModel: Model?
	
	@Binding var saved: Bool		
	
	let arView = CustomARView(frame: .zero)
	let config = ARWorldTrackingConfiguration()
	
	let spotLight = SpotLighting()
	let lightAnchor = AnchorEntity()
		
	func makeUIView(context: Context) -> ARView {
				
		// add altar to scene with ARAnchor for stability
		
		let altarARAnchor = ARAnchor(name: "AltarARAnchor", transform: simd_float4x4(diagonal: [1.0, 1.0, 1.0, 1.0]))
		
		let altarAnchorEntity = AnchorEntity(anchor: altarARAnchor)
		altarAnchorEntity.addChild(arView.altar)
		altarAnchorEntity.addChild(lightAnchor)
		lightAnchor.addChild(spotLight)
		arView.scene.anchors.append(altarAnchorEntity)
		arView.session.add(anchor: altarARAnchor)
		
		print("in makeUIView")
				
//		arView.addCoaching()
//
//		arView.scene.anchors.append(lightAnchor)

				
		config.planeDetection = [.horizontal]
		config.environmentTexturing = .automatic
		if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
			config.sceneReconstruction = .mesh
		}
		
		arView.enableObjectRemoval()
		arView.playAnimation()
		 
		// arView.scene.anchors.append(arView.box)
		arView.session.delegate = arView
		arView.session.run(config)
		
		
		
		if let saveUrl = url {
			self.loadWorldMap(url: saveUrl)
		}
		
		return arView
		
	}
	
	func updateUIView(_ uiView: ARView, context: Context) {
		
		print("in updateUIView")
		
		if let model = self.selectedModel {
			
			let virtualObjectAnchor = ARAnchor(name: model.modelName, transform: simd_float4x4(diagonal: [1.0, 1.0, 1.0, 1.0]))
		

			// Add ARAnchor into ARView.session, which can be persisted in WorldMap
			arView.session.add(anchor: virtualObjectAnchor)
		}
	
		DispatchQueue.main.async {
			self.selectedModel = nil
		}
	
		if saved {
			self.saveWorldMap()
		}
	}
	
	func generateMapSaveURL() -> URL {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM-d-yyyy-h-mm-a"
		let filename = dateFormatter.string(from: Date())
		
		do {
			return try FileManager.default
				.url(for: .documentDirectory,
					 in: .userDomainMask,
					 appropriateFor: nil,
					 create: true)
				.appendingPathComponent("map.\(filename)") // pass in filename as variable
		} catch {
			fatalError("Can't get file save URL: \(error.localizedDescription)")
		}
	}
}
