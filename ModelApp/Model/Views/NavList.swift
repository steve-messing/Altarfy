//
//  SwiftUIAltarListView.swift
//  SimpleGame
//
//  Created by Sophie Messing on 1/25/21.
//

import SwiftUI

struct NavList: View {
	
	@State var files: [URL] = []

	var body: some View {
		List {
			ForEach(files, id: \.self) { file in
				NavigationLink(destination: ContentView(url: file)) {
					HStack {
						Image(systemName: "square.and.pencil")
							.resizable()
							.padding(.all, 11.0)
							.frame(width: 50, height: 50)
						Text("\(file.pathExtension)")
						Spacer()
					}
				}
			}.onDelete(perform: delete)
		}.onAppear(perform: updateList)
    }
	
	func delete(at offsets: IndexSet) {
		files.remove(atOffsets: offsets)
	}
	
	func updateList() {
		print("updating list")
		do {
			let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
			let docs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options:  .skipsHiddenFiles)
			self.files = docs
		} catch {
			print("unable to get files!")
		}
	}
}

struct NavList_Previews: PreviewProvider {
    static var previews: some View {
		NavList()
    }
}
