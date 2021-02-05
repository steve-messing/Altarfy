//
//  LandmarkRow.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import Foundation
import SwiftUI

struct LandmarkRow: View {
	var landmark: Landmark
	
	var body: some View {
		HStack {
			Image(systemName: "square.and.pencil")
				.resizable()
				.padding(.all, 8.0)
				.frame(width: 50, height: 50)
			Text(landmark.name)
			
			Spacer()
		}
	}
}

struct LandmarkRow_Previews: PreviewProvider {
	static var previews: some View {
		LandmarkRow(landmark: landmarks[5])
	}
}
