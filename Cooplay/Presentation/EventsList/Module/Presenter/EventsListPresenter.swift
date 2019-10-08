//
//  EventsListPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTModelStorage

final class EventsListPresenter {
    
    private enum Constant {
        
        enum Section {
            
            static let invited = 0
            static let active = 1
            static let future = 2
        }
    }

    // MARK: - Properties

    weak var view: EventsListViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.fetchEvents()
                self?.view.updateProfile(with: AvatarViewModel(with: HardcodedConstants.me_ontime))
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
                self.configureInvitedSection(with: events.filter({ $0.me.status == .unknown }))
                let acceptedEvents = events.filter({ $0.me.status != .unknown && $0.me.status != .declined })
                if let activeEvent = acceptedEvents.first {
                    self.configureActiveSection(with: activeEvent)
                }
                self.configureFutureSection(with: acceptedEvents.suffix(acceptedEvents.count - 1))
            case .failure(let error):
                break
            }
        }
    }
    
    private func configureInvitedSection(with events: [Event]) {
        dataSource.setItems(events.map({ EventCellViewModel(with: $0)}), forSection: Constant.Section.invited)
        dataSource.setSectionHeaderModel(
            R.string.localizable.eventsListSectionsInvited(),
            forSection: Constant.Section.invited
        )
    }
    
    private func configureActiveSection(with event: Event) {
        dataSource.setItems([EventCellViewModel(with: event)], forSection: Constant.Section.active)
        dataSource.setSectionHeaderModel(
            R.string.localizable.eventsListSectionsActive(),
            forSection: Constant.Section.active
        )
    }
    
    private func configureFutureSection(with events: [Event]) {
        dataSource.setItems(events.map({ EventCellViewModel(with: $0)}), forSection: Constant.Section.future)
        dataSource.setSectionHeaderModel(
            R.string.localizable.eventsListSectionsFuture(),
            forSection: Constant.Section.future
        )
    }
}

// MARK: - EventsListModuleInput

extension EventsListPresenter: EventsListModuleInput {

}
