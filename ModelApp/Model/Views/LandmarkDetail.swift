//
//  PlaceHolderUniqueGamePage.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import SwiftUI

struct LandmarkDetail: View {
	var landmark: Landmark
	
	var body: some View {
		VStack {
			Text("\(landmark.name)")
		}
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
		LandmarkDetail(landmark: landmarks[0])
    }
}
