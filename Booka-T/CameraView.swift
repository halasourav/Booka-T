//
//  CameraView.swift
//  Booka-T
//
//  Created by Sourav Bhattacharjee on 19/10/24.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var hasCapturedImage: Bool  // Track if an image is captured
    @Environment(\.presentationMode) var presentationMode  // Add this line

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView

        init(parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.hasCapturedImage = true  // Set to true when an image is captured
            }
            parent.presentationMode.wrappedValue.dismiss()  // Dismiss the camera view
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.hasCapturedImage = false  // Reset to false when canceled
            parent.presentationMode.wrappedValue.dismiss()  // Dismiss the camera view
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates required
    }
}


//#Preview {
//    CameraView(, image: Image(systemName: "lamp.table.fill"))
//}
