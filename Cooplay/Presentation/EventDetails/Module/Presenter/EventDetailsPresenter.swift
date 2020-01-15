//
//  EventDetailsPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation

final class EventDetailsPresenter {

    // MARK: - Properties

    weak var view: EventDetailsViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: EventDetailsInteractorInput!
    var router: EventDetailsRouterInput!
    
    // MARK: - Private
    
    private var event: Event!
}

// MARK: - EventDetailsModuleInput

extension EventDetailsPresenter: EventDetailsModuleInput {

    func configure(with event: Event) {
        self.event = event
    }
}
