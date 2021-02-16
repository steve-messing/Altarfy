//
//  CustomARView+Coaching.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/15/21.
//

import ARKit
import RealityKit

// useful but not currently in use.

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
