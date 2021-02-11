//
//  CustomARView.swift
//  ARPersistence-Realitykit
//
//  Created by hgp on 1/17/21.
//
import SwiftUI
import RealityKit
import ARKit

class CustomARView: ARView {
    // Referring to @EnvironmentObject
	
	let box = try! Experience.loadBox()
	
	required init(frame frameRect: CGRect) {
		super.init(frame: frameRect)
	}
	
	@objc required dynamic init?(coder decoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
}
