//
//  EventsListPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import DTModelStorage
import iCarousel

final class EventsListPresenter: NSObject {
    
    private enum Constant {
        
        enum Section {
            
            static let active = 0
            static let future = 1
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
    private var events = [Event]()
    private var inventedEvents: [Event] {
        return events.filter({ $0.me.state == .unknown })
    }
    
    private func fetchEvents() {
        view.showProgress(indicatorType: .arrows)
        interactor.fetchEvents { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success(let events):
                self.events = events
                self.configureInvitedSection(with: events.filter({ $0.me.state == .unknown }))
                let acceptedEvents = events.filter({ $0.me.state != .unknown && $0.me.state != .declined })
                if let activeEvent = acceptedEvents.first {
                    self.configureActiveSection(with: activeEvent)
                }
                self.configureFutureSection(with: acceptedEvents.suffix(acceptedEvents.count - 1))
                self.view.showItems()
            case .failure(let error):
                break
            }
        }
    }
    
    private func configureInvitedSection(with events: [Event]) {
        view.setInvitations(show: !inventedEvents.isEmpty, dataSource: self)
    }
    
    private func configureActiveSection(with event: Event) {
        dataSource.setItems([ActiveEventCellViewModel(with: event)], forSection: Constant.Section.active)
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

// MARK: - iCarouselDataSource

extension EventsListPresenter: iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return inventedEvents.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let itemView = view as? InvitedEventCell ?? InvitedEventCell(isSmall: inventedEvents.count > 1)
        let item = inventedEvents[index]
        itemView.update(with: EventCellViewModel(with: item))
        return itemView
    }
}

// MARK: - EventsListModuleInput

extension EventsListPresenter: EventsListModuleInput {

}
