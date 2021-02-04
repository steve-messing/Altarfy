////
////  SaveButton.swift
////  ModelApp
////
////  Created by Sophie Messing on 2/3/21.
////
//
//import SwiftUI
//
//struct SaveButton: View {
//
//	@EnvironmentObject
//
//    var body: some View {
//		VStack {
//			Button(action: {
//				print("DEBUG: Save ARWorld map.")
//
//				Save.saveExperience()
//
//			}) {
//				Text("Save Experience")
//					.padding(.horizontal, 14)
//					.padding(.vertical, 8)
//
//			}
//			.background(saveLoadState.saveButton.isEnabled ? Color.blue : Color.gray)
//			.font(.system(size: 15))
//			.foregroundColor(.white)
//			.cornerRadius(8)
//			.disabled(!saveLoadState.saveButton.isEnabled)
//		}
//    }
//}
//
//struct SaveButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveButton()
//			.environmentObject(SaveLoadState())
//    }
//}
