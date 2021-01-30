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
	
	@State private var isPlacementEnabled = false
	@State private var selectedModel: Model?
//	@State private var modelConfirmedForPlacement: Model?
	
	private var models: [Model] = { // initialize an array of models
		
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
		ZStack {
			ZStack(alignment: .bottom) {
				ARViewContainer(selectedModel: self.$selectedModel)
				
//				if self.isPlacementEnabled {
//					PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled,
//										 selectedModel: self.$selectedModel,
//										 modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
//				} else {
					ModelPickerView(selectedModel: self.$selectedModel,
									models: self.models)
//				}
			}
		}
    }
}


struct ARViewContainer: UIViewRepresentable {
	
	typealias UIViewType = ARView
	
	@Binding var selectedModel: Model?
	
	let arView = ARView(frame: .zero)
	let anchor = AnchorEntity(plane: .horizontal)
	let config = ARWorldTrackingConfiguration()
	let boxAnchor = CustomBox(color: .white)
	
	
    func makeUIView(context: Context) -> ARView {
        
		arView.scene.addAnchor(anchor)
		config.planeDetection = [.horizontal]
		config.environmentTexturing = .automatic
		
		if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
			config.sceneReconstruction = .mesh
		}
		
		arView.session.run(config)
		
		return arView
        
    }
    
	func updateUIView(_ uiView: ARView, context: Self.Context) {
				
		if let model = self.selectedModel {
			
			if let modelEntity = model.modelEntity {
				
				modelEntity.scale = SIMD3<Float>(0.001, 0.001, 0.001)

				let parentEntity = ModelEntity()
				parentEntity.addChild(modelEntity)
				
				arView.installGestures([.all], for: parentEntity)
				
				parentEntity.generateCollisionShapes(recursive: true)
				anchor.generateCollisionShapes(recursive: true)
				
				anchor.addChild(parentEntity) // bug: .clone(recursive: true) breaks the gestures!!

			}
						
			DispatchQueue.main.async {
				self.selectedModel = nil
			}
		}
	}
}


// box helper method to make platform

class CustomBox: Entity, HasModel, HasAnchoring, HasCollision {
	
	required init(color: UIColor) {
		super.init()
		self.components[ModelComponent] = ModelComponent(
			mesh: .generateBox(size: 0.4, cornerRadius: 0.01),
			materials: [SimpleMaterial(
				color: color,
				roughness: 2,
				isMetallic: false
			)
			]
		)
	}
	
	convenience init(color: UIColor, position: SIMD3<Float>) {
		self.init(color: color)
		self.position = [-0.6, -1, -2]
	}
	
	required init() {
		fatalError("init() has not been implemented")
	}
}


// VIEWS

// Model Picker View

struct ModelPickerView: View {
//	@Binding var isPlacementEnabled: Bool
	@Binding var selectedModel: Model?
	 
	var models: [Model]
	
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 30) {
				ForEach(0 ..< self.models.count) { index in
					Button(action: {
						print(self.models[index])
//						self.isPlacementEnabled = true
						self.selectedModel = self.models[index]
						
					}) {
//						Image(uiImage: self.models[index].image)
						Image(uiImage: UIImage(named: "teapot")!)
							.resizable()
							.frame(width: 50, height: 50)
							.aspectRatio(1/1, contentMode: .fit)
							.background(Color.white)
							.cornerRadius(12)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
		}
		.padding(20)
		.background(Color.black.opacity(0.5))
	}
}


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
