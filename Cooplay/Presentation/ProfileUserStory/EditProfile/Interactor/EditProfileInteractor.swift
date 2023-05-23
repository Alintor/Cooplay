//
//  EditProfileInteractor.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

enum EditProfileError: Error {
    
    case errorEditProfile
}

extension EditProfileError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .errorEditProfile: return "Changed name" // TODO:
        }
    }
}

final class EditProfileInteractor {
    
    private let userService: UserServiceType
    weak var output: EditProfileInteractorOutput?
    
    // MARK: - Init
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
}

extension EditProfileInteractor: EditProfileInteractorInput {
    
    func editProfile(actions: [EditAction]) {
        Task.detached {
            do {
                for action in actions {
                    switch action {
                    case .updateName(let name):
                        try await self.userService.updateNickName(name)
                    case .deleteImage(let path):
                        try await self.userService.deleteAvatar(path: path, needClear: true)
                    case .addImage(let image):
                        try await self.userService.uploadNewAvatar(image)
                    case .updateImage(let image, let lastPath):
                        try await self.userService.deleteAvatar(path: lastPath, needClear: false)
                        try await self.userService.uploadNewAvatar(image)
                    }
                }
                await self.output?.didEditProfile()
                
            } catch {
                await self.output?.errorOccured(.errorEditProfile)
            }
        }
    }
    
}
