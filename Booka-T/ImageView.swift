//
//  ImageView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

struct ImageView: View {
    var image: UIImage
    @State private var regions: [Region] = [] // Track all highlighted regions
    @State private var currentPoints: [CGPoint] = [] // Track points of the current region
    @State private var showTagView = false // State for modal presentation
    
    var body: some View {
        ZStack {
            VStack {
                GeometryReader { geometry in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newPoint = value.location
                                    currentPoints.append(newPoint)
                                }
                                .onEnded { _ in
                                    // End of drawing
                                }
                        )
                    
                    // Draw the previously saved regions
                    ForEach(regions) { region in
                        Path { path in
                            guard !region.points.isEmpty else { return }
                            path.move(to: region.points[0])
                            for point in region.points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(region.color.toColor().opacity(0.5), lineWidth: 5)
                    }

                    
                    // Draw the current region being created
                    Path { path in
                        guard !currentPoints.isEmpty else { return }
                        path.move(to: currentPoints[0])
                        for point in currentPoints.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(Color.red.opacity(0.5), lineWidth: 5)
                }
                
                HStack {
                    Spacer()
                    Button(action: clearSelection) {
                        Text("Clear")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    Spacer()
                    Button(action: {
                        showTagView = true
                    }) {
                        Text("Tag")
                            .font(.system(size: 20))
                    }
                    Spacer()
                    Button(action: saveSelection) {
                        Text("Save")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .background(Color.black.opacity(0.8))
        .sheet(isPresented: $showTagView, onDismiss: updateRegionColor) {
            if let lastPoint = currentPoints.last {
                TagView(x: lastPoint.x, y: lastPoint.y, onSave: saveRegion)
            }
        }
    }
    
    private func clearSelection() {
        currentPoints.removeAll() // Clear only the current selection
    }
    
    private func saveRegion(name: String) {
        // Add the current points as a new region with a name and default color
        let newRegion = Region(id: UUID(), points: currentPoints, color: CodableColor(from: .green), name: name)
        regions.append(newRegion)
        currentPoints.removeAll() // Reset current points for a new selection
    }
    
    private func updateRegionColor() {
        // Change the color of the last selected region to green when dismissing the TagView
        if let lastIndex = regions.indices.last {
            regions[lastIndex].color = CodableColor(red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0) // Green color
        }
    }

}

extension ImageView {
    private func saveSelection() {
        guard let imageData = image.pngData() else { return } // Convert the image to Data
        
        let newImageData = ImageData(id: UUID(), imageData: imageData, regions: regions)
        
        // Retrieve existing data from UserDefaults
        var savedImages = loadSavedImages()
        savedImages.append(newImageData)
        
        // Store updated list in UserDefaults
        if let encodedData = try? JSONEncoder().encode(savedImages) {
            UserDefaults.standard.set(encodedData, forKey: "SavedImages")
        }
        
        // Reset the ImageView for a new selection
        currentPoints.removeAll()
        regions.removeAll()
        
        // Dismiss ImageView
        // Your code to dismiss the ImageView goes here (if necessary)
    }
    
    private func loadSavedImages() -> [ImageData] {
        if let savedData = UserDefaults.standard.data(forKey: "SavedImages"),
           let decodedImages = try? JSONDecoder().decode([ImageData].self, from: savedData) {
            return decodedImages
        }
        return []
    }
}

struct Region: Identifiable, Codable {
    let id: UUID
    var points: [CGPoint]
    var color: CodableColor
    var name: String
}

struct CodableColor: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(red: Double, green: Double, blue: Double, opacity: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.opacity = opacity
    }

    init(from color: Color) {
        self.red = color.components.red
        self.green = color.components.green
        self.blue = color.components.blue
        self.opacity = color.components.opacity
    }

    func toColor() -> Color {
        return Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}


extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

struct ImageData: Identifiable, Codable {
    let id: UUID
    var imageData: Data
    var regions: [Region]
}




//#Preview {
//    ImageView()
//}
