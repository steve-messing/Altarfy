////
////  StackingView.swift
////  ModelApp
////
////  Created by Sophie Messing on 1/27/21.
////
//
//import SwiftUI
//import UIKit
//import RealityKit
//
//
//struct StackingView: View {
//    var body: some View {
//        return ARViewContainer()
//    }
//}
//
//struct ARViewContainer: UIViewRepresentable {
//	
//	typealias UIViewType = ARView
//	
//	func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> ARView {
//		let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
//		
//		return arView
//	}
//	
//	func updateUIView(_ uiView: ARView, context: UIViewRepresentableContext<ARViewContainer>) {
//		
//	}
//}
//
//extension ARView {
//	func enableTapGesture() {
//		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
//		self.addGestureRecognizer(tapGestureRecognizer)
//	}
//	
//	@objc func handleTap(recognizer: UITapGestureRecognizer) {
//		let tapLocation = recognizer.location(in: self)
//		
//		guard let rayResult = self.ray(through: tapLocation) else { return }
//		
//		let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
//		
//		if let firstResult = results.first {
//			// Raycast intersected with AR Object
//			// Place object on top of existing AR object
//			
//			var position = firstResult.position
//			position.y += 0.3/2 // fix this programatically
//			placeCube(at: position)
//			
//		} else {
//			// the rayCast did not intersect with AR object
//			// place object on real world surface if detected
//			
//			let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
//			if let firstResult = results.first {
//				let position = simd_make_float3(firstResult.worldTransform.columns.3)
//				placeCube(at: position)
//			}
//		}
//	}
//	
//	func placeCube(at position: SIMD3<Float>) {
//		let mesh = MeshResource.generateBox(size: 0.3)
//		let material = SimpleMaterial(color: .white, roughness:  0.3, isMetallic: true)
//		let modelEntity = ModelEntity(mesh: mesh, materials: [material])
//		modelEntity.generateCollisionShapes(recursive: true)
//		
//		let anchorEntity = AnchorEntity(world: position)
//		anchorEntity.addChild(modelEntity)
//	}
//}
//
//
//struct StackingView_Previews: PreviewProvider {
//    static var previews: some View {
//        StackingView()
//    }
//}
