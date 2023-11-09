//
//  EditSheetView.swift
//  Cooplay
//
//  Created by Alexandr on 08.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EditSheetView : UIViewControllerRepresentable {
    
    @Binding var showAlert: Bool
    let canDelete: Bool
    let cameraAction: (() -> Void)?
    let photoAction: (() -> Void)?
    let deleteAction: (() -> Void)?

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
         guard context.coordinator.alert == nil && showAlert else { return }
         
         let alert = UIAlertController(
             title: nil,
             message: nil,
             preferredStyle: .actionSheet
         )
         context.coordinator.alert = alert
         let cameraAction = UIAlertAction(
             title: Localizable.editProfileAlertMakePhoto(),
             style: .default
         ) { _ in
             self.cameraAction?()
             alert.dismiss(animated: true) {
                self.showAlert = false
            }
         }
         cameraAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")
         cameraAction.setValue(R.image.commonCamera()!, forKey: "image")
         cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
         alert.addAction(cameraAction)
         let libraryAction = UIAlertAction(
             title: Localizable.editProfileAlertChoosePhoto(),
             style: .default
         ) { _ in
             self.photoAction?()
         }
         libraryAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")
         libraryAction.setValue(R.image.commonGallery()!, forKey: "image")
         libraryAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
         alert.addAction(libraryAction)
         if canDelete {
             let deleteAction = UIAlertAction(
                 title: Localizable.commonDelete(),
                 style: .default
             ) { _ in
                 self.deleteAction?()
             }
             alert.addAction(deleteAction)
             deleteAction.setValue(R.color.red(), forKey: "titleTextColor")
             deleteAction.setValue(R.image.commonDelete()!, forKey: "image")
             deleteAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
         }
         let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel)
         cancelAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")
         alert.addAction(cancelAction)
         
         DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                self.showAlert = false
                context.coordinator.alert = nil
            })
                         
        }
     }

     func makeUIViewController(context: Context) -> some UIViewController {
         
         return UIViewController()
     }
    
    func makeCoordinator() -> EditSheetView.Coordinator {
            Coordinator(self)
    }
    
    final class Coordinator: NSObject {

        var alert: UIAlertController?
        var control: EditSheetView
            
        init(_ control: EditSheetView) {
            self.control = control
        }
    }
}
