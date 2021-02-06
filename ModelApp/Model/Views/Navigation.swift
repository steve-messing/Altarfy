//
//  Navigation.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import SwiftUI

struct Navigation: View {
    var body: some View {
			NavigationView {
				VStack {
					NavigationLink(destination: ContentView()) {
						HStack { // add new
							Image(systemName: "plus.circle")
								.resizable()
								.padding(.all, 8.0)
								.frame(width: 50, height: 50)
							Text("Create New Altar")
								.fontWeight(.bold)
								.padding([.top, .bottom, .trailing])
							
							Spacer()
							}
						.padding()
						}
					LandmarkList()
				}
				.navigationTitle("My Altars")
			}
		}
    }


struct Navigation_Previews: PreviewProvider {
    static var previews: some View {
        Navigation()
    }
}
