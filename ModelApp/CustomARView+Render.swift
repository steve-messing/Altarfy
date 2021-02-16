//
//  CustomARView+Render.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/15/21.
//

import RealityKit
import ARKit

extension CustomARView {
	
	public func addAnchorEntityToScene(anchor: ARAnchor) {
		
		print("adding \(anchor.name ?? "anchor name") to scene as ARAnchor")
		
		print(anchor.transform)
		
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
}
