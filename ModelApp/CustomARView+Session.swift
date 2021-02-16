//
//  CustomARView+Session.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/15/21.
//

import RealityKit
import ARKit

extension CustomARView: ARSessionDelegate {
	
	public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
		
		print("---starting the session---")
		for anchor in anchors {
			addAnchorEntityToScene(anchor: anchor)
		}
	}
	
//	public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//		for anchor in anchors
//		{
//			guard let anchor = anchor as? ARAnchor else { continue }
//			let transform = anchor.transform
//			updateTransform(anchor: anchor, tranform: transform)
//		}
//	}
}
