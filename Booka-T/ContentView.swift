//
//  ContentView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var capturedImage: UIImage? = nil
    @State private var isCameraPresented = false
    @State private var isImageViewPresented = false
    @State private var isImageDetailPresented = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedCoordinates: [Coordinate]? = nil // Change to Coordinate
    @State private var hasCapturedImage = false

    var body: some View {
        NavigationView {
            TabView {
                ImagesView(selectedImage: $selectedImage, selectedCoordinates: $selectedCoordinates, isImageDetailPresented: $isImageDetailPresented)
                    .tabItem {
                        Image(systemName: "photo.fill")
                        Text("Images")
                    }

                Text("Opening Camera...")
                    .onAppear {
                        isCameraPresented = true
                    }
                    .fullScreenCover(isPresented: $isCameraPresented, onDismiss: {
                        if hasCapturedImage {
                            isImageViewPresented = true
                        }
                    }) {
                        CameraView(image: $capturedImage, hasCapturedImage: $hasCapturedImage)
                    }
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Camera")
                    }
            }
            .background(
                NavigationLink(
                    destination: ImageView(image: capturedImage ?? UIImage()),
                    isActive: $isImageViewPresented,
                    label: {
                        EmptyView()
                    }
                )
                .background(
                    NavigationLink(
                        destination: DetailedImageView(image: selectedImage ?? UIImage(), coordinates: selectedCoordinates ?? []), // Pass Coordinate
                        isActive: $isImageDetailPresented,
                        label: {
                            EmptyView()
                        }
                    )
                )
            )
        }
    }
}


//#Preview {
//    ContentView()
//}

