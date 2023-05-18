//
//  EditProfilePresenter.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

final class EditProfilePresenter {
    
    // MARK: - Properties
    
    private weak var view: EditProfileViewInput?
    private let interactor: EditProfileInteractorInput
    private let router: EditProfileRouterInput
    
    // MARK: - Init
    
    init(
        view: EditProfileViewInput?,
        interactor: EditProfileInteractorInput,
        router: EditProfileRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

}

// MARK: - EditProfileViewOutput

extension EditProfilePresenter: EditProfileViewOutput {
    
    func didLoad() {

    }
    
    func didTapSave() {
        guard let view = view else { return }
        
        view.showProgress(indicatorType: .arrows, fullScreen: true)
        interactor.editProfile(actions: view.editActions)
    }
    
    func didTapAvatar() {
        guard let view = view else { return }
        
        router.showAvatarActionAlert(canDelete: view.canDeleteAvatar) { [weak self] in
            self?.view?.removeAvatar()
        }
    }
    
    func addNewAvatarImage(_ image: UIImage) {
        view?.addNewAvatarImage(image)
    }
    
}

// MARK: - EditProfileInteractorOutput

extension EditProfilePresenter: EditProfileInteractorOutput {
    
    func didEditProfile() {
        view?.hideProgress()
        router.close(animated: true)
    }
    
    func errorOccured(_ error: EditProfileError) {
        view?.hideProgress()
        print(error.localizedDescription)
    }
    
}

// MARK: - EditProfileModuleInput

extension EditProfilePresenter: EditProfileModuleInput { }
