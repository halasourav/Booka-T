//
//  TagView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

struct TagView: View {
    var x: CGFloat
    var y: CGFloat
    @State private var regionName: String = ""
    @Environment(\.presentationMode) var presentationMode
    var onSave: (String) -> Void

    var body: some View {
        VStack {
            TextField("Enter name for the region", text: $regionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button(action: {
                    // Dismiss without saving
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                
                Button(action: {
                    onSave(regionName)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Tag Region")
    }
}



//#Preview {
//    TagView()
//}
