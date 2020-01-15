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
                guard let `self` = self else { return }
                self.view.setupInitialState()
                self.view.update(with: EventDetailsViewModel(with: self.event))
            }
            view.statusAction = { [weak self] delegate in
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .large,
                    menuType: .statuses(type: .confirmation, actionHandler: { status in
                        guard let `self` = self else { return }
                        self.event.me.status = status
                        self.view.update(with: EventDetailsViewModel(with: self.event))
                    })
                )
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
