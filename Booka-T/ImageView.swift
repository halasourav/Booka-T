//
//  ImageView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI

import SwiftUI

struct ImageView: View {
    var image: UIImage

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.black.opacity(0.8))
                .edgesIgnoringSafeArea(.all)
        }
    }
}


//#Preview {
//    ImageView()
//}
