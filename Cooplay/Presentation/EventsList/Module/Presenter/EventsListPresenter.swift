//
//  EventsListPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation

final class EventsListPresenter {

    // MARK: - Properties

    weak var view: EventsListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
        }
    }
    var interactor: EventsListInteractorInput!
    var router: EventsListRouterInput!
}

// MARK: - EventsListModuleInput

extension EventsListPresenter: EventsListModuleInput {

}
