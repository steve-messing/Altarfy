//
//  ContentView.swift
//  ModelApp
//
//  Created by Sophie Messing on 1/26/21.
//

import SwiftUI
import UIKit
import RealityKit
import ARKit

//struct ContentView : View {
//	
//	@State public var selectedModel: Model?
//	@State public var models: [Model] = {
//	@State var saver = false
//		
//		let filemanager = FileManager.default
//		
//		guard let path = Bundle.main.resourcePath, let files = try?
//			filemanager.contentsOfDirectory(atPath: path)
//			else {
//			return []
//		}
//		
//		var availableModels: [Model] = []
//		
//		for filename in files where filename.hasSuffix("usdz") {
//			let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
//			let model = Model(modelName: modelName)
//			availableModels.append(model)
//		}
//		return availableModels
//	}()
//	
//	var body: some View { // display UI buttons and list
//		VStack {
//			ZStack(alignment: .bottom) {
//				ARViewContainer(saved: $saver, selectedModel: self.$selectedModel).edgesIgnoringSafeArea(.all)
//				ModelPickerView(selectedModel: self.$selectedModel, models: self.$models)
//				
//			}
//			HStack {
//				Spacer()
//				Button(action: { self.saver.toggle() }) {
//					Text("Save")
//				}
//				Spacer()
//		}
//    }
//}









// Placement Buttons View

//struct PlacementButtonsView: View {
//	@Binding var isPlacementEnabled: Bool
//	@Binding var selectedModel: Model?
//	@Binding var modelConfirmedForPlacement: Model?
//
//	var body: some View {
//		HStack {
//
//			// cancel button
//			Button(action: {
//				print("cancel model placement")
//				self.resetPlacementParameters()
//			}) {
//				Image(systemName: "xmark")
//					.frame(width: 50, height: 50)
//					.font(.title)
//					.background(Color.white.opacity(0.75))
//					.cornerRadius(25)
//					.padding(20)
//			}
//
//			// confirm button
//			Button(action: {
//				print("confirm model placement")
//
//				self.modelConfirmedForPlacement = self.selectedModel
//
//				self.resetPlacementParameters()
//			}) {
//				Image(systemName: "checkmark")
//					.frame(width: 50, height: 50)
//					.font(.title)
//					.background(Color.white.opacity(0.75))
//					.cornerRadius(25)
//					.padding(20)
//			}
//		}
//	}
//	func resetPlacementParameters() {
//		self.isPlacementEnabled = false
//		self.selectedModel = nil
//	}
//}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
