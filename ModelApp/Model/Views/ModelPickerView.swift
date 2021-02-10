//
//  ModelPickerView.swift
//  ModelApp
//
//  Created by Sophie Messing on 1/31/21.
//

import SwiftUI
import UIKit
import RealityKit
import ARKit

struct ModelPickerView: View {
	
	@Binding var selectedModel: Model?
	@Binding var models: [Model]
		
	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 30) {
				ForEach(0 ..< self.models.count) { index in
					Button(action: {
						print(self.models[index].modelName)
						self.selectedModel = self.models[index]
						
					}) {
						Image(uiImage: self.models[index].image)
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
