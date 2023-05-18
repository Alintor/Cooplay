//
//  EditProfileRouter.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

final class EditProfileRouter {
    
    weak var rootViewController: UIViewController?
    
    // MARK: - Private Methods
    
    private func openPhotosFetcher(fromCamera: Bool) {
        guard
            let delegate = rootViewController as? UIImagePickerControllerDelegate&UINavigationControllerDelegate
        else {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        imagePicker.sourceType = fromCamera ? .camera : .photoLibrary
        rootViewController?.present(imagePicker, animated: true)
    }
}

extension EditProfileRouter: EditProfileRouterInput {
    
    func showAvatarActionAlert(canDelete: Bool, deleteHandler: (() -> Void)?) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        //alert.view.tintColor = R.color.actionAccent()
        let cameraAction = UIAlertAction(
            title: Localizable.editProfileAlertMakePhoto(),
            style: .default
        ) { [weak self] _ in
            self?.openPhotosFetcher(fromCamera: true)
        }
        cameraAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")
        cameraAction.setValue(R.image.commonCamera()!, forKey: "image")
        cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(cameraAction)
        let libraryAction = UIAlertAction(
            title: Localizable.editProfileAlertChoosePhoto(),
            style: .default
        ) { [weak self] _ in
            self?.openPhotosFetcher(fromCamera: false)
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
                deleteHandler?()
            }
            alert.addAction(deleteAction)
            deleteAction.setValue(R.color.red(), forKey: "titleTextColor")
            deleteAction.setValue(R.image.commonDelete()!, forKey: "image")
            deleteAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        }
        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel)
        cancelAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")

        alert.addAction(cancelAction)
        rootViewController?.present(alert, animated: true, completion:  nil)
    }
}
