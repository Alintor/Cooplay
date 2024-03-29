//
//  EditProfileState.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI
import AVFoundation

enum EditAction: Hashable {
    
    case updateName(_ name: String)
    case deleteImage(path: String)
    case updateImage(image: UIImage, lastPath: String)
    case addImage(_ image: UIImage)
}

final class EditProfileState: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let profile: Profile
    private let userService: UserServiceType
    @Published var name: String
    @Published var image: UIImage?
    @Published var avatarPath: String?
    @Published var showAvatarSheet: Bool = false
    @Published var showPhotoPicker: Bool = false
    @Published var showPermissionsAlert: Bool = false
    @Published var showProgress: Bool = false
    var photoPickerTypeCamera = true
    let avatarBackgroundColor: UIColor
    var needShowProfileAvatar: Binding<Bool>?
    var isBackButton: Binding<Bool>
    let isPersonalization: Bool
    let backAction: (() -> Void)?
    
    // MARK: - Init
    
    init(
        store: Store,
        profile: Profile,
        userService: UserServiceType,
        needShowProfileAvatar: Binding<Bool>?,
        isBackButton: Binding<Bool>,
        isPersonalization: Bool,
        backAction: (() -> Void)?
    ) {
        self.store = store
        self.profile = profile
        self.userService = userService
        self.name = profile.name
        self.avatarPath = profile.avatarPath
        self.avatarBackgroundColor = UIColor.avatarBackgroundColor(profile.id)
        self.needShowProfileAvatar = needShowProfileAvatar
        self.isBackButton = isBackButton
        self.isPersonalization = isPersonalization
        self.backAction = backAction
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
    
    @MainActor private func handleEditResult(isSuccess: Bool) {
        showProgress = false
        if isSuccess {
            guard !isPersonalization else { return }
            
            store.dispatch(.showNotificationBanner(.init(title: Localizable.editProfileSuccessTitle(), type: .success)))
            backAction?()
        } else {
            store.dispatch(.showNetworkError(UserServiceError.editProfile))
        }
    }
    
    func removeAvatar() {
        image = nil
        avatarPath = nil
    }
    
    func saveChange() {
        showProgress = true
        Task.detached { [weak self] in
            do {
                for editAction in self?.editActions ?? [] {
                    switch editAction {
                    case .updateName(let name):
                        try await self?.userService.updateNickName(name)
                    case .deleteImage(let path):
                        try await self?.userService.deleteAvatar(path: path, needClear: true)
                    case .addImage(let image):
                        try await self?.userService.uploadNewAvatar(image)
                    case .updateImage(let image, let lastPath):
                        try await self?.userService.deleteAvatar(path: lastPath, needClear: false)
                        try await self?.userService.uploadNewAvatar(image)
                    }
                }
                await self?.handleEditResult(isSuccess: true)
            } catch {
                await self?.handleEditResult(isSuccess: false)
            }
        }
    }
    
    func addImage(_ image: UIImage) {
        self.image = image
    }
    
    func checkPermissions() {
        AVCaptureDevice.requestAccess(for: .video) {  granted in
            DispatchQueue.main.async { [weak self] in
                if granted {
                    self?.photoPickerTypeCamera = true
                    self?.showPhotoPicker = true
                } else {
                    self?.showPermissionsAlert = true
                }
            }
        }
    }
    
    func openSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
}

private enum Constant {
    
    static let minSymbols = 2
    static let maxSymbols = 12
    static let wrongSymbol = " "
}
