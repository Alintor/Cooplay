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

    weak var view: PersonalisationViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                guard let `self` = self else { return }
                self.view.setupInitialState()
                self.view.updateAvatar(with: AvatarViewModel(with: self.user))
                
            }
            view.confirmAction = { [weak self] in
                self?.confirmChanges()
            }
            view.changeAvatarAction = { [weak self] in
            }
            view.nickNameChanged = { [weak self] value in
                guard let `self` = self, let nickname = value else { return }
                self.view.clearNickNameErrorMessage()
                self.user.name = nickname
                self.view.updateAvatar(with: AvatarViewModel(with: self.user))
                if let error = self.interactor.validateNickName(nickname) {
                    self.handleError(error)
                } else {
                    self.isNickNameCorrect = true
                }
                self.view.setConfirmButtonEnabled(self.isNickNameCorrect)
            }
        }
    }
    var interactor: PersonalisationInteractorInput!
    var router: PersonalisationRouterInput!
    
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

// MARK: - PersonalisationModuleInput

extension PersonalisationPresenter: PersonalisationModuleInput {

    func configure(with user: User) {
        self.user = user
    }
}
