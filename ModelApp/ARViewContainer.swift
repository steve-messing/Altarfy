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
import CoreData


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
				.appendingPathComponent("map.Altar-\(filename)") // pass in filename as variable
		} catch {
			fatalError("Can't get file save URL: \(error.localizedDescription)")
		}
	}
}


extension CustomARView {
	
//	func addAnchorEntityToScene(anchor: ARAnchor, transform: SIMD3<Float>) {
	func addAnchorEntityToScene(anchor: ARAnchor) {

		print("adding \(anchor.name ?? "anchor name") to scene as ARAnchor")

		guard anchor.name != nil else {
			return
		}

		// Add modelEntity and anchorEntity into the scene for rendering

		if let modelEntity = try? ModelEntity.loadModel(named: anchor.name ?? "Stone_06") {
			
//			modelEntity.setPosition(transform, relativeTo: altar)
			modelEntity.scale = SIMD3(0.001, 0.001, 0.001)
			modelEntity.generateCollisionShapes(recursive: true)
			self.installGestures(for: modelEntity)

			self.altar.addChild(modelEntity)
			modelEntity.setPosition(SIMD3<Float>(0, 0.97, -0.3), relativeTo: self.altar)
		} else {
			print("DEBUG: Unable to add modelEntity to scene in Render")
		}
	}

	
	// double tap to delete
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
	
	// long press for animations
	
	func playAnimation() {
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
		
		self.addGestureRecognizer(longPressGestureRecognizer)
	}
	
	@objc func handleLongPress(recognizer: UILongPressGestureRecognizer) {
		let location = recognizer.location(in: self)
		
		if let entity = self.entity(at: location) {
			entity.availableAnimations.forEach { entity.playAnimation($0.repeat()) }
		}
	}
}

extension CustomARView: ARSessionDelegate {

	public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
		
		print("---starting the session---")
		for anchor in anchors {
			addAnchorEntityToScene(anchor: anchor)
		}
	}
	
//	public func session(_ session: ARSession, didUpdate anchors: [ARAnchor])
//	{
//		for anchor in anchors
//		{
//			guard let anchor = anchor as? ARAnchor else { continue }
//			let transform = anchor.transform
//			updateTransform(anchor: anchor, tranform: transform)
//		}
//	}
	
}


extension CustomARView: ARCoachingOverlayViewDelegate {
	func addCoaching() {
		// Create a ARCoachingOverlayView object
		let coachingOverlay = ARCoachingOverlayView()
		// Make sure it rescales if the device orientation changes
		coachingOverlay.autoresizingMask = [
			.flexibleWidth, .flexibleHeight
		]
		self.addSubview(coachingOverlay)
		// Set the Augmented Reality goal
		coachingOverlay.goal = .horizontalPlane
		// Set the ARSession
		coachingOverlay.session = self.session
		// Set the delegate for any callbacks
		coachingOverlay.delegate = self
	}
}
