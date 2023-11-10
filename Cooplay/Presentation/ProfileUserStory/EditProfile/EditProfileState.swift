//
//  EditProfileState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

enum EditAction: Hashable {
    
    case updateName(_ name: String)
    case deleteImage(path: String)
    case updateImage(image: UIImage, lastPath: String)
    case addImage(_ image: UIImage)
}

class EditProfileState: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let profile: Profile
    @Published var name: String
    @Published var image: UIImage?
    @Published var avatarPath: String?
    @Published var showAvatarSheet: Bool = false
    @Published var showPhotoPicker: Bool = false
    var photoPickerTypeCamera = true
    let avatarBackgroundColor: UIColor
    var needShowProfileAvatar: Binding<Bool>?
    
    // MARK: - Init
    
    init(
        store: Store,
        profile: Profile,
        needShowProfileAvatar: Binding<Bool>?
    ) {
        self.store = store
        self.profile = profile
        self.name = profile.name
        self.avatarPath = profile.avatarPath
        self.avatarBackgroundColor = UIColor.avatarBackgroundColor(profile.id)
        self.needShowProfileAvatar = needShowProfileAvatar
    }
    
    // MARK: - Computed properties
    
    private var editActions: [EditAction] {
        var actions = [EditAction]()
        if isNameChanged && isNameValid {
            actions.append(.updateName(name))
        }
        if isAvatarChanged {
            if let image = image, profile.avatarPath == nil {
                actions.append(.addImage(image))
            }
            if let image = image, let path = profile.avatarPath {
                actions.append(.updateImage(image: image, lastPath: path))
            }
            if let path = profile.avatarPath, image == nil, avatarPath != path {
                actions.append(.deleteImage(path: path))
            }
        }
        return actions
    }
    
    var isNameValid: Bool {
        if
            name.count < Constant.minSymbols ||
            name.count > Constant.maxSymbols ||
            name.contains(Constant.wrongSymbol)
        {
            return false
        }
        return true
    }
    
    var nameFirstLetter: String {
        name.firstBigLetter
    }
    var isButtonDisabled: Bool {
        !(isNameValid && (isNameChanged || isAvatarChanged))
    }
    var isNameChanged: Bool {
        name != profile.name
    }
    
    var isAvatarChanged: Bool {
        image != nil || avatarPath != profile.avatarPath
    }
    
    var canDeleteAvatar: Bool {
        image != nil || avatarPath != nil
    }
    
    // MARK: - Methods
    
    func removeAvatar() {
        image = nil
        avatarPath = nil
    }
    
    func saveChange() {
        store.send(.editActions(editActions))
    }
    
}

// MARK: - UIImagePickerControllerDelegate + UINavigationControllerDelegate

extension EditProfileState: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        self.image = image
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

private enum Constant {
    
    static let minSymbols = 2
    static let maxSymbols = 12
    static let wrongSymbol = " "
}
