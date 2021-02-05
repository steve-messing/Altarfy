////
////  thumbnailGenerator.swift
////  ModelApp
////
////  Created by Sophie Messing on 1/30/21.
////
//
//import QuickLookThumbnailing
//import SwiftUI
//import UIKit
//import Combine
//
//class ThumbnailGenerator : ObservableObject {
//	
//	@Published var thumbnailImage: Image?
//	
//	func generateThumbnail(for resource: String, withExtension: String = "usdz", size: CGSize) {
//		guard let url = Bundle.main.url(forResource: resource, withExtension: withExtension) else {
//			print("unable to create url for resource")
//			return
//		}
//		
//		let scale = UIScreen.main.scale
//		let request = QLThumbnailGenerator.Request(fileAt: url, size: size, scale: scale, representationTypes: .all)
//		let generator = QLThumbnailGenerator.shared
//		
//		generator.generateRepresentations(for: request) { (thumbnail, type, error) in
//			DispatchQueue.main.async {
//				if thumbnail == nil || error != nil {
//					print("error generating thumbnail")
//				} else {
//					self.thumbnailImage = Image(uiImage: thumbnail!.uiImage)
//				}
//			}
//		}
//	}
//}
