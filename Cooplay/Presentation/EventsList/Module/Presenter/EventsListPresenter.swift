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
            
            static let invitations = 0
            static let active = 1
            static let future = 2
            static let declined = 3
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
            view.itemSelected = { [weak self] event in
                self?.router.openEvent(event)
            }
        }
    }
    var interactor: EventsListInteractorInput!
    var router: EventsListRouterInput!
    
    // MARK: - Private
    
    private var dataSource: MemoryStorage!
    private var events = [Event]() {
        didSet {
            events = events.sorted(by: { $0.date < $1.date })
        }
    }
    private var inventedEvents: [Event] {
        return events.filter({ $0.me.state == .unknown })
    }
    private var acceptedEvents: [Event] {
        return events.filter({ $0.me.state != .unknown && $0.me.state != .declined })
    }
    private var activeEvent: Event? {
        return acceptedEvents.first
    }
    private var furureEvents: [Event] {
        if activeEvent == nil {
            return acceptedEvents
        } else {
            return acceptedEvents.suffix(acceptedEvents.count - 1)
        }
    }
    private var declinedEvents: [Event] {
        return events.filter({ $0.me.state == .declined })
    }
    
    private var showDeclinedEvents: Bool = true
    
    private func updateEvent(_ event: Event) {
        if let index = events.firstIndex(of: event) {
            events[index] = event
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.configureSections()
            }
        }
    }
    
    private func fetchEvents() {
        view.showProgress(indicatorType: .arrows)
        interactor.fetchEvents { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success(let events):
                self.events = events
                self.configureSections()
                self.view.showItems()
            case .failure(let error):
                break
            }
        }
    }
    
    private func configureSections() {
        configureInvitedSection()
        configureActiveSection()
        configureFutureSection()
        configureDeclinedSection()
    }
    
    private func configureInvitedSection() {
        let sectionHeader = inventedEvents.isEmpty ? nil : EventSectionСollapsibleHeaderViewModel(
            title: R.string.localizable.eventsListSectionsInvited(),
            itemsCount: inventedEvents.count,
            showItems: true,
            toggleAction: nil
        )
        let selectionAction: ((_ index: Int) -> Void)? = { [weak self] index in
            guard let `self` = self else { return }
            self.router.openEvent(self.inventedEvents[index])
        }
        let items = inventedEvents.isEmpty ? [] : [InvitationsHeaderCellViewModel(
            dataSource: self,
            selectionAction: selectionAction
        )]
        dataSource.setItems(items, forSection: Constant.Section.invitations)
        dataSource.setSectionHeaderModel(
            sectionHeader,
            forSection: Constant.Section.invitations
        )
    }
    
    private func configureActiveSection() {
        var events = [ActiveEventCellViewModel]()
        var sectionHeader: EventSectionСollapsibleHeaderViewModel?
        if var activeEvent = activeEvent {
            sectionHeader = EventSectionСollapsibleHeaderViewModel(
                title: R.string.localizable.eventsListSectionsActive(),
                itemsCount: nil,
                showItems: true,
                toggleAction: nil
            )
            events.append(ActiveEventCellViewModel(with: activeEvent, statusAction: { [weak self] delegate in
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .moveToBottom,
                    menuSize: .large,
                    menuType: .statuses(type: .confirmation, actionHandler: { status in
                        activeEvent.me.status = status
                        self?.updateEvent(activeEvent)
                    })
                )
            }))
        }
        dataSource.setItems(events, forSection: Constant.Section.active)
        dataSource.setSectionHeaderModel(
            sectionHeader,
            forSection: Constant.Section.active
        )
        
    }
    
    private func configureFutureSection() {
        var viewModels = [EventCellViewModel]()
        for var event in furureEvents {
            let viewModel = EventCellViewModel(with: event) { [weak self] delegate in
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .small,
                    menuType: .statuses(
                        type: .agreement,
                        actionHandler: { status in
                            event.me.status = status
                            self?.updateEvent(event)
                        }
                    )
                )
            }
            viewModels.append(viewModel)
        }
        let sectionHeader = furureEvents.isEmpty ? nil : EventSectionСollapsibleHeaderViewModel(
            title: R.string.localizable.eventsListSectionsFuture(),
            itemsCount: furureEvents.count,
            showItems: true,
            toggleAction: nil
        )
        dataSource.setItems(viewModels, forSection: Constant.Section.future)
        dataSource.setSectionHeaderModel(
            sectionHeader,
            forSection: Constant.Section.future
        )
    }
    
    private func configureDeclinedSection() {
        var viewModels = [EventCellViewModel]()
        for var event in declinedEvents {
            let viewModel = EventCellViewModel(with: event) { [weak self] delegate in
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .small,
                    menuType: .statuses(
                        type: .agreement,
                        actionHandler: { status in
                            event.me.status = status
                            self?.updateEvent(event)
                        }
                    )
                )
            }
            viewModels.append(viewModel)
        }
        dataSource.setItems(showDeclinedEvents ? viewModels : [], forSection: Constant.Section.declined)
        
        let sectionHeader = declinedEvents.isEmpty ? nil : EventSectionСollapsibleHeaderViewModel(
            title: R.string.localizable.eventsListSectionsDeclined(),
            itemsCount: declinedEvents.count,
            showItems: showDeclinedEvents,
            toggleAction: { [weak self] in
                guard let `self` = self else { return }
                self.showDeclinedEvents = !self.showDeclinedEvents
                self.configureDeclinedSection()
            }
        )
        
        dataSource.setSectionHeaderModel(
            sectionHeader,
            forSection: Constant.Section.declined
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
        var item = inventedEvents[index]
        itemView.update(with: InvitedEventCellViewModel(with: item, statusAction: { [weak self] action in
            switch action {
            case .accept:
                item.me.status = .accepted
                self?.updateEvent(item)
            case .details(let delegate):
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .small,
                    menuType: .statuses(
                        type: .agreement,
                        actionHandler: { status in
                            item.me.status = status
                            self?.updateEvent(item)
                        }
                    )
                )
            }
        }))
        return itemView
    }
}

// MARK: - EventsListModuleInput

extension EventsListPresenter: EventsListModuleInput {

}
