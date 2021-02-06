//
//  SwiftUIAltarListView.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
		List(landmarks) { landmark in
			NavigationLink(destination: LandmarkDetail(landmark: landmark)) {
				LandmarkRow(landmark: landmark)
			}
		}
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
