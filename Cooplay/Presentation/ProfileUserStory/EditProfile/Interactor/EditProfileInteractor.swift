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
        Task {
            do {
                for action in actions {
                    switch action {
                    case .updateName(let name):
                        try await userService.updateNickName(name)
                    case .deleteImage(let path):
                        break
                    case .updateImage(let image, let lastPath):
                        break
                    case .addImage(let image):
                        break
                    }
                }
                await output?.didEditProfile()
                
            } catch {
                await output?.errorOccured(.errorEditProfile)
            }
        }
    }
    
}
