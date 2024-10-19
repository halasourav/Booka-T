//
//  DetailedImageView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

import SwiftUI

struct DetailedImageView: View {
    var image: UIImage
    var coordinates: [Coordinate] // Use the new Coordinate struct

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

                    // Draw highlights based on coordinates
                    ForEach(coordinates, id: \.self) { coordinate in
                        Circle() // or any shape you prefer
                            .fill(Color.green.opacity(0.5))
                            .frame(width: 10, height: 10) // Size of the highlight
                            .position(coordinate.point) // Use the CGPoint inside Coordinate
                    }
                }

                HStack {
                    Spacer()
                    Button(action: {
                        // Dismiss action if needed
                    }) {
                        Text("Back")
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
    }
}


struct Coordinate: Hashable {
    var point: CGPoint
    
    init(_ point: CGPoint) {
        self.point = point
    }
    
    // Implementing hash function
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
    
    // Equatable implementation
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.point == rhs.point
    }
}

//#Preview {
//    DetailedImageView()
//}
