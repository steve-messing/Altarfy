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
		
		let mapSaveURL = generateMapSaveURL()
		print(mapSaveURL)
		
		print("in saveWorldMap")
		arView.session.getCurrentWorldMap { worldMap, error in
			print("in callback")
			guard let map = worldMap else {
				print("returning because no world map")
				print(error!.localizedDescription)
				return
			}
			
			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
				try data.write(to: mapSaveURL, options: [.atomic])
				print("\(map)")
			} catch {
				fatalError("Can't save map: \(error.localizedDescription)")
			}
			
			print("---SAVING---")
			print(map.anchors)
			print("saved to \(mapSaveURL)")
			saved = false
		}
	}
	
	func loadWorldMap(url: URL) {
		
		let mapSaveURL = url

		let worldMap: ARWorldMap = {
						
			print("loading from \(mapSaveURL)")
			
			guard let data = try? Data(contentsOf: mapSaveURL)
			
			
			else {
				fatalError("No map data found")
			}
			
			do {
				guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
				else { fatalError("No ARWorldMap in archive.") }
				print("unarchiving \(worldMap.anchors)")
				return worldMap
			
			} catch {
				fatalError("Can't unarchive ARWorldMap from file data: \(error)")
			}
		}()
		
		print("---LOADING---")
		print(worldMap.anchors)
		
		config.initialWorldMap = worldMap
		arView.session.run(config, options: [.resetTracking])
	}
}




