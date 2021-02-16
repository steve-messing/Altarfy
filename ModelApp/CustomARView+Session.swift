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
//		for anchor in anchors {
//			let transform = anchor.transform
//			addAnchorEntityToScene(anchor: anchor)
//		}
//	}
}
