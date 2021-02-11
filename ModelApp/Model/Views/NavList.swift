//
//  SwiftUIAltarListView.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import SwiftUI

struct NavList: View {
	
	var files: [URL] = {
		do {
			let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			let docs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options:  .skipsHiddenFiles)
			return docs
		} catch {
			print("unable to get files!")
			return []
		}
	}()
		
	var body: some View {
		List(files, id: \.self) { file in
			NavigationLink(destination: ContentView()) {
				HStack {
					Image(systemName: "square.and.pencil")
						.resizable()
						.padding(.all, 8.0)
						.frame(width: 50, height: 50)
					Text("\(file)")
					Spacer()
				}
			}
		}
    }
}

struct NavList_Previews: PreviewProvider {
    static var previews: some View {
		NavList()
    }
}
