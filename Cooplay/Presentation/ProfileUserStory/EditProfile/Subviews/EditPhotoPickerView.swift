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
    weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
    
    private func getPermissionsPicker() -> UIAlertController {
        let alert = UIAlertController(
            title: Localizable.editProfilePermissionsAlertTitle(),
            message: nil,
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(
            title: Localizable.editProfilePermissionsAlertSetting(),
            style: .default
        ) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        settingsAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")
        alert.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel)
        cancelAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")

        alert.addAction(cancelAction)
        
        return alert
    }

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
         guard context.coordinator.alert == nil && showAlert else { return }
         
         let imagePicker = UIImagePickerController()
         imagePicker.delegate = delegate
         imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
         context.coordinator.alert = imagePicker
         
         if fromCamera {
             AVCaptureDevice.requestAccess(for: .video) {  granted in
                 DispatchQueue.main.async {
                     uiViewController.present(
                        granted ? imagePicker : getPermissionsPicker(),
                        animated: true,
                        completion: {
                            self.showAlert = false
                            context.coordinator.alert = nil
                        }
                    )
                 }
             }
         } else {
             DispatchQueue.main.async {
                 uiViewController.present(imagePicker, animated: true, completion: {
                    self.showAlert = false
                    context.coordinator.alert = nil
                }
            )
         }
                         
        }
     }

     func makeUIViewController(context: Context) -> some UIViewController {
         
         return UIViewController()
     }
    
    func makeCoordinator() -> EditPhotoPickerView.Coordinator {
            Coordinator(self)
    }
    
    final class Coordinator: NSObject {

        var alert: UIImagePickerController?
        var control: EditPhotoPickerView
            
        init(_ control: EditPhotoPickerView) {
            self.control = control
        }
    }
}
