//
//  EditProfileViewController.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Combine

final class EditProfileViewController: UIHostingController<EditProfileView> {

    private weak var output: EditProfileViewOutput?
    
    init(contentView: EditProfileView, output: EditProfileViewOutput?) {
        self.output = output
        super.init(rootView: contentView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        output?.didLoad()
    }
    
    // MARK: - Private
    
    private func setupView() {
        isModalInPresentation = true
        navigationItem.title = Text.title
    }
    
}

// MARK: - UIImagePickerControllerDelegate + UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(
            UIImagePickerController.InfoKey.originalImage
        )] as? UIImage else {
            return
        }
        
        output?.addNewAvatarImage(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Helper function inserted by Swift 4.2 migrator.

private func convertFromUIImagePickerControllerInfoKeyDictionary(
    _ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

private func convertFromUIImagePickerControllerInfoKey(
    _ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// MARK: - Constants

private enum Text {
    
    static let title = Localizable.editProfileTitle()
}
