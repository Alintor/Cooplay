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
                self?.fetchProfile()
            }
            view.viewDidAppear  = { [weak self] in
                self?.fetchEvents()
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                self?.dataSource = dataSource
            }
            view.itemSelected = { [weak self] event in
                self?.router.openEvent(event)
            }
            view.newEventAction = { [weak self] in
                self?.router.openNewEvent()
            }
            view.profileAction = { [weak self] in
                self?.router.openProfile()
            }
        }
    }
    var interactor: EventsListInteractorInput!
    var router: EventsListRouterInput!
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInviteDeepLink),
            name: .handleDeepLinkInvent,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchEvents),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private var isFirstShowing = true
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
        return acceptedEvents.first { $0.isActive }
    }
    private var furureEvents: [Event] {
        if let activeEvent = activeEvent {
            return acceptedEvents.filter { $0.id != activeEvent.id }
        } else {
            return acceptedEvents
        }
    }
    private var declinedEvents: [Event] {
        return events.filter({ $0.me.state == .declined })
    }
    
    private var showDeclinedEvents: Bool {
        get {
            return interactor.showDeclinedEvents
        }
        set {
            interactor.setDeclinedEvents(show: newValue)
        }
    }
    
    private func updateEvent(_ event: Event) {
        interactor.changeStatus(for: event) { [weak self] result in
            switch result {
            case .success: break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchProfile() {
        interactor.fetchProfile { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let user):
                self.view.updateProfile(with: AvatarViewModel(with: user))
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func fetchEvents() {
        guard dataSource != nil else { return }
        if isFirstShowing {
            view.showProgress(indicatorType: .arrows)
            isFirstShowing = false
        }
        interactor.fetchEvents { [weak self] result in
            guard let `self` = self else { return }
            self.view?.hideProgress()
            switch result {
            case .success(let events):
                self.events = events
                self.configureSections()
                self.view?.showItems()
                self.interactor.updateAppBadge(inventedEventsCount: self.inventedEvents.count)
                var furureEvents = self.furureEvents
                self.activeEvent.map { furureEvents.append($0) }
                self.interactor.setupNotifications(events: furureEvents)
                self.handleInviteDeepLink()
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
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
                    menuType: .statuses(type: .confirmation, date: activeEvent.date, actionHandler: { status in
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
                        type: event.isActive ? .confirmation : .agreement,
                        date: event.date,
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
                        date: event.date,
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
    
    @objc private func handleInviteDeepLink() {
        guard let eventId = interactor.inventLinkEventId else { return }
        interactor.clearInventLinkEventId()
        interactor.addEvent(eventId: eventId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let event):
                self.router.openEvent(event)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
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
                        date: item.date,
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
