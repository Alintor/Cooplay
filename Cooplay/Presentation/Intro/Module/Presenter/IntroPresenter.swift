//
//  IntroPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

final class IntroPresenter {

    // MARK: - Properties

    weak var view: IntroViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
            view.authAction = { [weak self] in
                self?.router.openAuthorization()
            }
            view.registerAction = { [weak self] in
                self?.router.openRegistration()
            }
        }
    }
    var interactor: IntroInteractorInput!
    var router: IntroRouterInput!
}

// MARK: - IntroModuleInput

extension IntroPresenter: IntroModuleInput {

}
