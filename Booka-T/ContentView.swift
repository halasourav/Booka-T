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
    @State private var hasCapturedImage = false  // Track if an image is captured

    var body: some View {
        NavigationView {
            TabView {
                TablesView()
                    .tabItem {
                        Image(systemName: "table.furniture.fill")
                        Text("Tables")
                    }

                // Show the "Opening Camera..." text initially
                Text("Opening Camera...")
                    .onAppear {
                        // Open the camera when the tab is selected
                        isCameraPresented = true
                    }
                    .fullScreenCover(isPresented: $isCameraPresented, onDismiss: {
                        // Navigate to ImageView only if an image was captured
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
            )
        }
    }
}



#Preview {
    ContentView()
}
