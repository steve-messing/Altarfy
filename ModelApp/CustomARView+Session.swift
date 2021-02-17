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
		
		for anchor in anchors {
			addAnchorEntityToScene(anchor: anchor)
		}
	}
}
