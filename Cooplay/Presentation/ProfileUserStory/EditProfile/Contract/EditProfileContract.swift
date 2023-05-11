//
//  EditProfileContract.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol EditProfileViewInput: AnyObject {
    
}

protocol EditProfileViewOutput: AnyObject {
    
    func didLoad()
}

// MARK: - Interactor

protocol EditProfileInteractorInput: AnyObject { }

protocol EditProfileInteractorOutput: AnyObject { }

// MARK: - Router

protocol EditProfileRouterInput: AnyObject { }

// MARK: - ModuleInput

protocol EditProfileModuleInput { }
