//
//  RegistrationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Foundation

final class RegistrationPresenter {

    // MARK: - Properties

    weak var view: RegistrationViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: RegistrationInteractorInput!
    var router: RegistrationRouterInput!
}

// MARK: - RegistrationModuleInput

extension RegistrationPresenter: RegistrationModuleInput {

}
