//
//  SaveAndLoad.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/3/21.


import SwiftUI
import UIKit
import ARKit
import RealityKit


extension ARViewContainer {

	func saveWorldMap() {
		arView.session.getCurrentWorldMap { worldMap, _ in
			guard let map = worldMap else {
				return
			}
				
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "YYYYMMdd-hhmmss"
				
			let fileName = "\(dateFormatter.string(from: Date()))"
			print(fileName)
			
			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
				let savedMap = UserDefaults.standard
				savedMap.set(data, forKey: fileName)
			} catch {
				fatalError("Can't save map: \(error.localizedDescription)")
			}
			
			print("SAVED")
			DispatchQueue.main.async {
				saved = false
			}
		}
	}
}




