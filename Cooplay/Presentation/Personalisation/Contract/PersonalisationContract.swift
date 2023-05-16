//
//  PersonalisationContract.swift
//  Cooplay
//
//  Created by Alexandr on 16.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol PersonalisationViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    func setupInitialState()
    func updateAvatar(with model: AvatarViewModel)
    func showNickNameErrorMessage(_ message: String)
    func clearNickNameErrorMessage()
    func setConfirmButtonEnabled(_ isEnabled: Bool)
}

protocol PersonalisationViewOutput: AnyObject {
    
    func didLoad()
    func didTapConfirm()
    func didTapChangeAvatar()
    func didChangeName(_ nickName: String?)
}

// MARK: - Interactor

protocol PersonalisationInteractorInput: AnyObject {

    func validateNickName(_ nickname: String) -> PersonalisationError?
    func setNickname(_ nickname: String, completion: @escaping (Result<Void, PersonalisationError>) -> Void)
}

// MARK: - Router

protocol PersonalisationRouterInput: StartRoutable { }

// MARK: - Module Input

protocol PersonalisationModuleInput: AnyObject {

    func configure(with user: User)
}
