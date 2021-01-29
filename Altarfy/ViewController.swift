//
//  ViewController.swift
//  ModelApp
//
//  Created by Sophie Messing on 1/26/21.
//

import Foundation
import UIKit
import SwiftUI
import RealityKit

class ViewController: UIViewController {
	
	@IBOutlet var arView: ARView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Load the "Box" scene from the "Experience" Reality File
		let boxAnchor = try! Experience.loadBox()
		
		// Add the box anchor to the scene
		arView.scene.anchors.append(boxAnchor)
	}
}
