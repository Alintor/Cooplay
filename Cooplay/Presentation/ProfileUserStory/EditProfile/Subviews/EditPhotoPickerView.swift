//
//  PhotoPickerView.swift
//  Cooplay
//
//  Created by Alexandr on 08.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import AVFoundation

struct EditPhotoPickerView : UIViewControllerRepresentable {
    
    @Binding var showAlert: Bool
    let fromCamera: Bool
    var imageHandler: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

     func makeUIViewController(context: Context) -> some UIViewController {
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = context.coordinator
         imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
         return imagePicker
     }
    
    func makeCoordinator() -> EditPhotoPickerView.Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.imageHandler
        )
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
            
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                onImagePicked(image)
            }
            picker.dismiss(animated: true) {
                self.onDismiss()
            }
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.onDismiss()
            }
        }
        
    }
}
