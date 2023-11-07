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

class EditProfileState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let profile: Profile
    @Published var isInProgress: Bool
    @Published var name: String
    @Published var image: UIImage?
    @Published var avatarPath: String?
    let avatarBackgroundColor: UIColor
    var isShown: Binding<Bool>?
    var needShowProfileAvatar: Binding<Bool>?
    
    // MARK: - Init
    
    init(
        store: Store,
        profile: Profile,
        isShown: Binding<Bool>?,
        needShowProfileAvatar: Binding<Bool>?
    ) {
        self.store = store
        self.profile = profile
        self.isInProgress = store.state.value.user.isEditInProgress
        self.name = profile.name
        self.avatarPath = profile.avatarPath
        self.avatarBackgroundColor = UIColor.avatarBackgroundColor(profile.id)
        self.isShown = isShown
        self.needShowProfileAvatar = needShowProfileAvatar
        store.state
            .map { $0.user.isEditInProgress }
            .removeDuplicates()
            .assign(to: &$isInProgress)
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
    
    func addNewAvatarImage(_ image: UIImage) {
        self.image = image
    }
    
    func saveChange() {
        store.send(.editProfileActions(editActions))
    }
    
    func close() {
        isShown?.wrappedValue = false
    }
    
}

private enum Constant {
    
    static let minSymbols = 2
    static let maxSymbols = 12
    static let wrongSymbol = " "
}
