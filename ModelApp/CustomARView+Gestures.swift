//
//  CustomARView+Gestures.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/15/21.
//

import RealityKit
import ARKit

extension CustomARView {
	
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
