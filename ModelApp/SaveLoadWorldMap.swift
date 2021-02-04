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
		print("in saveWorldMap")
		arView.session.getCurrentWorldMap { worldMap, _ in
			print("in callback")
			guard let map = worldMap else {
				print("returning because no world map")
				return
			}
				
			// let dateFormatter = DateFormatter()
			// dateFormatter.dateFormat = "YYYYMMdd-hhmmss"
				
			// let fileName = "\(dateFormatter.string(from: Date()))"
			
			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
				let savedMap = UserDefaults.standard
				savedMap.set(data, forKey: "WorldMap")
			} catch {
				fatalError("Can't save map: \(error.localizedDescription)")
			}
			
			print("WorldMap saved")
			saved = false
		}
	}
	
	func loadWorldMap() {

		let storedData = UserDefaults.standard

		if let data = storedData.data(forKey: "WorldMap") {
	
			print("getting storedData")
			
			if let unarchiver = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARWorldMap.classForKeyedUnarchiver()], from: data),
			   let worldMap = unarchiver as? ARWorldMap {
				print("unarchiving...\(worldMap)")
				config.initialWorldMap = worldMap
				arView.session.run(config)
				print("successfully loaded")
				loaded = false
			}
		} else {
			print("unable to load data!")
			loaded = false
		}
	}
}




