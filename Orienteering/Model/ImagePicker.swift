//
//  ImagePicker.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 25/6/2023.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator

    // A binding property that stores the selected image.
    @Binding var image: UIImage?
    
    // An environment property that dismisses the view controller when the user is done selecting an image.
    @Environment(\.presentationMode) var presentationMode

    // An inner class that acts as the delegate for the UIImagePickerController and handles the user's selection of an image.
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        // Initializes a new instance of the ImagePickerCoordinator class with a parent ImagePicker view.
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // Called when the user selects an image from the UIImagePickerController. Updates the ImagePicker view's image property with the selected image, and dismisses the view.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        // Called when the user cancels the selection of an image from the UIImagePickerController. Dismisses the view without updating the ImagePicker view's image property.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    // Creates and returns an instance of the ImagePickerCoordinator class.
    func makeCoordinator() -> Coordinator {
        return ImagePickerCoordinator(self)
    }

    // Creates and configures a new instance of the UIImagePickerController class for displaying a view that allows the user to select an image from their photo library.
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    // Not used in this case.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
}
