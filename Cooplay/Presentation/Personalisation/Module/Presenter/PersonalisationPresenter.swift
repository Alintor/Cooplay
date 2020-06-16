//
//  PersonalisationPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Foundation

final class PersonalisationPresenter {

    // MARK: - Properties

    weak var view: PersonalisationViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: PersonalisationInteractorInput!
    var router: PersonalisationRouterInput!
}

// MARK: - PersonalisationModuleInput

extension PersonalisationPresenter: PersonalisationModuleInput {

}
