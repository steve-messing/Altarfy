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
		self.position.y = 1
		self.position.z = -0.5
	}
}



struct ARViewContainer: UIViewRepresentable {
	
	// typealias UIViewType = ARView
	
	@Binding var selectedModel: Model?
	
	@Binding var saved: Bool
	@Binding var loaded: Bool
		
	
	
	let arView = CustomARView(frame: .zero)
	let config = ARWorldTrackingConfiguration()
	
	let directionalLight = DirectionalLighting()
	let spotLight = SpotLighting()
	let lightAnchor = AnchorEntity()
	let parentAnchor = AnchorEntity()
		
	func makeUIView(context: Context) -> ARView {
				
		print("in makeUIView")
				
		arView.addCoaching()

		arView.scene.anchors.append(lightAnchor)
		lightAnchor.addChild(spotLight)
				
		config.planeDetection = [.horizontal]
		config.environmentTexturing = .automatic
		if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
			config.sceneReconstruction = .mesh
		}
		
		arView.enableObjectRemoval()
		arView.playAnimation()
		 
		arView.scene.addAnchor(arView.box)
		arView.session.delegate = arView
		arView.session.run(config)
		config.planeDetection = []
		
		
		
		// load if arrived from load in main navigation
		// load the correct scene
		// else return fresh arview
		
		
		return arView
		
	}
	
	func updateUIView(_ uiView: ARView, context: Context) {
		
		print("in updateUIView")
		
		if let model = self.selectedModel {
		
			if let modelEntity = model.modelEntity {
			
				let virtualObjectAnchor = ARAnchor(name: model.modelName, transform: simd_float4x4(
								[1.0, 0.0, 0.0, 0.0],
								[0.0, 1.0, 0.0, 0.0],
								[0.0, 0.0, 1.0, 0.0],
								[0.0, 0.0, 0.0, 1.0]))
			
			
//				modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
//				modelEntity.generateCollisionShapes(recursive: true)
//				arView.installGestures(for: modelEntity)
//
//				let anchorEntity = AnchorEntity(anchor: virtualObjectAnchor)
//				modelEntity.setPosition(SIMD3<Float>(0, 0.97, 0), relativeTo: boxAnchor)
//
//				anchorEntity.addChild(modelEntity)
//				boxAnchor.addChild(anchorEntity)
//				arView.scene.addAnchor(anchorEntity)

				// Add ARAnchor into ARView.session, which can be persisted in WorldMap
				arView.session.add(anchor: virtualObjectAnchor)
				}
			}
							
			// print(arView.scene.anchors)
		
			DispatchQueue.main.async {
				self.selectedModel = nil
			}
			
			print("saved is \(saved)")
			print("loaded is \(loaded)")
		
			if saved {
				self.saveWorldMap()
			}
		
			if loaded {
				self.loadWorldMap()
			}
		}
	
	func generateMapSaveURL() -> URL {
		
		// filename = datetime
		// prompt user to enter filename
		// .appendingPathComponent(filename)
		
		do {
			return try FileManager.default
				.url(for: .documentDirectory,
					 in: .userDomainMask,
					 appropriateFor: nil,
					 create: true)
				.appendingPathComponent("map.arexperience") // pass in filename as variable
		} catch {
			fatalError("Can't get file save URL: \(error.localizedDescription)")
		}
	}
}


extension CustomARView {
		
	func addAnchorEntityToScene(anchor: ARAnchor) {

//		let boxAnchor = try! Experience.loadBox()
		
		print("in addAnchorEntityToScene func")
		print("adding \(anchor.name ?? "anchor name") to scene as ARAnchor")

		guard anchor.name != nil else {
			return
		}

		// scope boxAnchor
		// positioning with simd_float4x4
		
		// Add modelEntity and anchorEntity into the scene for rendering
		let model = Model(modelName: anchor.name ?? "Stone_06")

		print(model.modelName)

		if let modelEntity = model.modelEntity {
			
			
			
//
//			let virtualObjectAnchor = ARAnchor(name: model.modelName, transform: simd_float4x4(
//												[1.0, 0.0, 0.0, 0.0],
//												[0.0, 1.0, 0.0, 0.0],
//												[0.0, 0.0, 1.0, 0.0],
//												[0.0, 0.0, 0.0, 1.0]))
//
//
//			modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
//			modelEntity.generateCollisionShapes(recursive: true)
//			arView.installGestures(for: modelEntity)
//
//			let anchorEntity = AnchorEntity(anchor: virtualObjectAnchor)
//			modelEntity.setPosition(SIMD3<Float>(0, 0.97, 0), relativeTo: boxAnchor)
//
//			anchorEntity.addChild(modelEntity)
//			boxAnchor.addChild(anchorEntity)
//			arView.scene.addAnchor(anchorEntity)
			
			
			
			
			modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
			modelEntity.generateCollisionShapes(recursive: true)
			self.installGestures(for: modelEntity)
			modelEntity.setPosition(SIMD3<Float>(0, 0.97, 0), relativeTo: self.box)

			let anchorEntity = AnchorEntity(anchor: anchor)
			anchorEntity.addChild(modelEntity)
			self.box.addChild(anchorEntity)
			self.scene.addAnchor(anchorEntity)
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

extension CustomARView: ARSessionDelegate { //session:DidAdd

	public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
		
		print("---starting the session---")
		for anchor in anchors {
			addAnchorEntityToScene(anchor: anchor)
		}
	}
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
