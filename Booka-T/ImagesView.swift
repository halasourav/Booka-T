//
//  TablesView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

struct ImagesView: View {
    @Binding var selectedImage: UIImage?
    @Binding var selectedCoordinates: [Coordinate]? // Change to [Coordinate]
    @Binding var isImageDetailPresented: Bool
    
    @State private var savedImages: [ImageData] = []

    var body: some View {
        ScrollView {
            let layout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

            LazyVGrid(columns: layout, spacing: 20) {
                ForEach(savedImages, id: \.id) { imageData in
                    if let uiImage = UIImage(data: imageData.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .onTapGesture {
                                selectedImage = uiImage
                                selectedCoordinates = imageData.regions.flatMap { $0.points.map { Coordinate($0) } } // Use Coordinate
                                isImageDetailPresented = true // Notify that an image was selected
                            }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadSavedImages()
        }
    }

    private func loadSavedImages() {
        if let savedData = UserDefaults.standard.data(forKey: "SavedImages"),
           let decodedImages = try? JSONDecoder().decode([ImageData].self, from: savedData) {
            savedImages = decodedImages
        }
    }
}

//#Preview {
//    ImagesView()
//}
