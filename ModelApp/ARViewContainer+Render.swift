////
////  CustomARView+Render.swift
////  ARPersistence-Realitykit
////
////  Created by hgp on 1/17/21.
////
//
//import Foundation
//import RealityKit
//import ARKit
//import UIKit
//import SwiftUI
//
//extension ARViewContainer {
//    
//    func addAnchorEntityToScene(anchor: ARAnchor) {
//        
//		guard anchor.name == "Stone_06" else {
//            return
//        }
//
//		// Add modelEntity and anchorEntity into the scene for rendering
//		if let modelEntity = Model(modelName: anchor.name!).modelEntity {
//			
//			modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)
//			modelEntity.generateCollisionShapes(recursive: true)
//			arView.installGestures(for: modelEntity)
//			modelEntity.setPosition(SIMD3<Float>(0, 0.97, -0.3), relativeTo: anchor)
//			
//			let anchorEntity = AnchorEntity(anchor: anchor)
//            anchorEntity.addChild(modelEntity)
//			self.arView.scene.addAnchor(anchorEntity)
//        } else {
//            print("DEBUG: Unable to add modelEntity to scene in Render")
//        }
//    }
//}
