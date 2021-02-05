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
		loaded = false
		print("in saveWorldMap")
		arView.session.getCurrentWorldMap { worldMap, _ in
			print("in callback")
			guard let map = worldMap else {
				print("returning because no world map")
				return
			}
				
			 let dateFormatter = DateFormatter()
			 dateFormatter.dateFormat = "YYYYMMdd-hhmmss"
				
			let fileName = "\(dateFormatter.string(from: Date()))"
			
			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
				let savedMap = UserDefaults.standard
				savedMap.set(data, forKey: fileName)
			} catch {
				fatalError("Can't save map: \(error.localizedDescription)")
			}
			
			print("\(fileName) saved")
			saved = false
		}
	}
	
	func loadWorldMap() {

		let storedData = UserDefaults.standard
		print("inside loadworldmap")
		print(UserDefaults.standard.dictionaryRepresentation().keys)
		if let data = storedData.data(forKey: "20210204-043105") {
	
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
	
	
//	func writeWorldMap(_ worldMap: ARWorldMap, to url: URL) throws {
//
//		let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap,
//													requiringSecureCoding: true)
//		try data.write(to: url)
//	}
//
//	func loadWorldMap(from url: URL) throws -> ARWorldMap {
//
//		let mapData = try Data(contentsOf: url)
//		guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self,
//																	from: mapData)
//		else {
//			throw ARError(.invalidWorldMap)
//		}
//		return worldMap
//	}
	
}




