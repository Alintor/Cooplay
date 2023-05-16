//
//  IntroContract.swift
//  Cooplay
//
//  Created by Alexandr on 15.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol IntroViewInput: AnyObject {

    func setupInitialState()
}

protocol IntroViewOutput {
    
    func didLoad()
    func didTapAuth()
    func didTapRegister()
}

// MARK: - Interactor

protocol IntroInteractorInput: AnyObject { }

// MARK: - Router

protocol IntroRouterInput: AnyObject {

    func openAuthorization()
    func openRegistration()
}

// MARK: - Module Input

protocol IntroModuleInput: AnyObject { }
