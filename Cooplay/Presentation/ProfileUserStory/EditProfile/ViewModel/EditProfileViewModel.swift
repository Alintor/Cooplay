//
//  EditProfileViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

final class EditProfileViewModel: ObservableObject {
    
    @Published var name: String
    @Published var image: UIImage?
    @Published var avatarPath: String?
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
    let avatarBackgroundColor: UIColor
    private let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
        name = profile.name
        avatarPath = profile.avatarPath
        avatarBackgroundColor = UIColor.avatarBackgroundColor(profile.id)
    }
    
    // MARK: - Private Methods
    
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
    
}

extension EditProfileViewModel: EditProfileViewInput {
    
    var editActions: [EditAction] {
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
    var canDeleteAvatar: Bool {
        image != nil || avatarPath != nil
    }
    
    func removeAvatar() {
        image = nil
        avatarPath = nil
    }
    
    func addNewAvatarImage(_ image: UIImage) {
        self.image = image
    }
}


private enum Constant {
    
    static let minSymbols = 2
    static let maxSymbols = 12
    static let wrongSymbol = " "
}
