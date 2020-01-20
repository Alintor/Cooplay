//
//  NewEventPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

final class NewEventPresenter {

    // MARK: - Properties

    weak var view: NewEventViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: NewEventInteractorInput!
    var router: NewEventRouterInput!
}

// MARK: - NewEventModuleInput

extension NewEventPresenter: NewEventModuleInput {

}
