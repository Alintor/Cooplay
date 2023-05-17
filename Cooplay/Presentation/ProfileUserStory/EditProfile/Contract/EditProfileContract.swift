//
//  EditProfileContract.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import UIKit

import Foundation

// MARK: - View

protocol EditProfileViewInput: AnyObject, ActivityIndicatorRenderer {
    
    var editActions: [EditAction] { get }
    func removeAvatar()
}

protocol EditProfileViewOutput: AnyObject {
    
    func didLoad()
    func didTapSave()
}

// MARK: - Interactor

protocol EditProfileInteractorInput: AnyObject {
    
    func editProfile(actions: [EditAction])
}

protocol EditProfileInteractorOutput: AnyObject {
    
    @MainActor func didEditProfile()
    @MainActor func errorOccured(_ error: EditProfileError)
}

// MARK: - Router

protocol EditProfileRouterInput: CloseableRouter { }

// MARK: - ModuleInput

protocol EditProfileModuleInput { }
