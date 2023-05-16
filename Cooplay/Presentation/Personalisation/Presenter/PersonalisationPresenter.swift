//
//  PersonalisationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation
import UIKit

final class PersonalisationPresenter {

    // MARK: - Properties

    private weak var view: PersonalisationViewInput!
    private let interactor: PersonalisationInteractorInput
    private let router: PersonalisationRouterInput
    
    // MARK: - Init
    
    init(
        view: PersonalisationViewInput,
        interactor: PersonalisationInteractorInput,
        router: PersonalisationRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private
    private var user: User!
    private var avatarImage: UIImage?
    private var isNickNameCorrect = false
    
    private func confirmChanges() {
        guard let nickname = user.name, !nickname.isEmpty else { return }
        view.showProgress(indicatorType: .arrows)
        interactor.setNickname(nickname) { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success:
                self.router.openEventList()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: PersonalisationError) {
        switch error {
        case .invalidNickName(let message):
            isNickNameCorrect = false
            view.showNickNameErrorMessage(message)
        case .unhandled:
            break
            // TODO:
        }
    }
}

// MARK: - PersonalisationViewOutput

extension PersonalisationPresenter: PersonalisationViewOutput {
    
    func didLoad() {
        view.setupInitialState()
        view.updateAvatar(with: AvatarViewModel(with: user))
    }
    
    func didTapConfirm() {
        confirmChanges()
    }
    
    func didTapChangeAvatar() {
        
    }
    
    func didChangeName(_ nickName: String?) {
        guard let nickname = nickName else { return }
        
        view.clearNickNameErrorMessage()
        user.name = nickname
        view.updateAvatar(with: AvatarViewModel(with: user))
        if let error = interactor.validateNickName(nickname) {
            handleError(error)
        } else {
            isNickNameCorrect = true
        }
        view.setConfirmButtonEnabled(isNickNameCorrect)
    }

}

// MARK: - PersonalisationModuleInput

extension PersonalisationPresenter: PersonalisationModuleInput {

    func configure(with user: User) {
        self.user = user
    }
}
