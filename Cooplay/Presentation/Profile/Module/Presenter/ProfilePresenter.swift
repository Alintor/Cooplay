//
//  ProfilePresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

final class ProfilePresenter {

    // MARK: - Properties

    weak var view: ProfileViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: ProfileInteractorInput!
    var router: ProfileRouterInput!
}

// MARK: - ProfileModuleInput

extension ProfilePresenter: ProfileModuleInput {

}
