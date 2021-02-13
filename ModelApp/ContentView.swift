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

struct ContentView : View {
	
	
	public var url: URL?

	@State var showsAlert = false
	
	@State private var saver = false
	
	@State public var selectedModel: Model?
	@State public var models: [Model] = {
		let filemanager = FileManager.default
		
		guard let path = Bundle.main.resourcePath, let files = try?
				filemanager.contentsOfDirectory(atPath: path)
		else {
			return []
		}
		
		var availableModels: [Model] = []
		
		for filename in files where filename.hasSuffix("usdz") {
			let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
			let model = Model(modelName: modelName)
			availableModels.append(model)
		}
		return availableModels
	}()
	
	var body: some View { // display UI buttons and list
		VStack {
			
			ZStack(alignment: .bottom) {
				
				ARViewContainer(url: url, selectedModel: self.$selectedModel, saved: $saver).edgesIgnoringSafeArea(.all)
				ModelPickerView(selectedModel: self.$selectedModel, models: self.$models)
			}
			
			HStack() {
				
				Spacer()
				
				Button(action: { self.saver.toggle() }) {
					Text("Save")
				}.padding(.trailing)
			}
		}
	}
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
