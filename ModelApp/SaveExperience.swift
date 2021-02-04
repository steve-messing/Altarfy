//
//  SaveAndLoad.swift
//  ModelApp
//
//  Created by Sophie Messing on 2/3/21.
//
//
//import SwiftUI
//import UIKit
//import ARKit
//import RealityKit
//
//
//extension ARViewContainer {
//
//	func saveExperience() {
//		arView.session.getCurrentWorldMap { worldMap, _ in
//			guard let map = worldMap else {
//				return
//			}
//			
//			let alert = UIAlertController(title: "Altar Name", message: "File name to save the Altar to.", preferredStyle: .alert)
//			alert.addTextField { (textField) in
//				let dateFormatter = DateFormatter()
//				dateFormatter.dateFormat = "YYYYMMdd-hhmmss"
//				
//				textField.text = "\(dateFormatter.string(from: Date()))"
//				textField.clearsOnInsertion = true
//			}
//			
//			let fileName = alert.textFields?.first?.text ?? "Untitled"
//			
//			do {
//				let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
//				let savedMap = UserDefaults.standard
//				savedMap.set(data, forKey: fileName)
//				savedMap.synchronize()
////					DispatchQueue.main.async {
////						self.saveLoadState.loadButton.isHidden = false
////						self.saveLoadState.loadButton.isEnabled = true
////					}
//			} catch {
//				fatalError("Can't save map: \(error.localizedDescription)")
//			}
//		}
//	}
//}




