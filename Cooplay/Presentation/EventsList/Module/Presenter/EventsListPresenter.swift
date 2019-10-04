//
//  EventsListPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTModelStorage

final class EventsListPresenter {

    // MARK: - Properties

    weak var view: EventsListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.fetchEvents()
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                self?.dataSource = dataSource
            }
        }
    }
    var interactor: EventsListInteractorInput!
    var router: EventsListRouterInput!
    
    // MARK: - Private
    
    private var dataSource: MemoryStorage!
    
    private func fetchEvents() {
        interactor.fetchEvents { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let events):
                self.dataSource.setItems(events.filter({ $0.me.status != .unknown }).map({ EventCellViewModel(with: $0 )}))
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: - EventsListModuleInput

extension EventsListPresenter: EventsListModuleInput {

}
