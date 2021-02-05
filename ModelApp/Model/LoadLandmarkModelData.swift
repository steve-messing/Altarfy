//
//  LandmarkModelData.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

// Create a load(_:) method that fetches JSON data with a given name from the app’s main bundle.
// use this later to load data from backend API
// note: The load method relies on the return type’s conformance to the Codable protocol.

import Foundation

var landmarks: [Landmark] = load("landmarkData.json")

func load<T: Decodable>(_ filename: String) -> T {
	let data: Data
	guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
	else {
		fatalError("Couldn't dind \(filename) in main bundle.")
	}
	
	do {
		data = try Data(contentsOf: file)
	} catch {
		fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
	}
	
	do {
		let decoder = JSONDecoder()
		return try decoder.decode(T.self, from: data)
	} catch {
		fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
	}
	
}
