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
            view.calendarAction = { [weak self] in
                self?.router.showCalendar{ [weak self] date in
                    self?.view.updateDayDate(with: NewEventDayDateViewModel(date: date))
                }
            }
            view.searchGameAction = { [weak self] in
                self?.router.openGameSearch()
            }
        }
    }
    var interactor: NewEventInteractorInput!
    var router: NewEventRouterInput!
}

// MARK: - NewEventModuleInput

extension NewEventPresenter: NewEventModuleInput {

}
