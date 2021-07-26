//
//  EventDetailsPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTModelStorage

final class EventDetailsPresenter {

    // MARK: - Properties

    weak var view: EventDetailsViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                guard let `self` = self else { return }
                self.view.setupInitialState()
                self.view.update(with: EventDetailsViewModel(with: self.event))
                self.view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: false)
                self.fetchEvent()
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                guard let `self` = self else { return }
                self.dataSource = dataSource
                self.dataSource.setItems(self.members.map { EventDetailsCellViewModel(with: $0, event: self.event) })
            }
            view.statusAction = { [weak self] delegate in
                guard let `self` = self else { return }
                self.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .large,
                    menuType: .statuses(
                        type: self.event.statusesType,
                        event: self.event,
                        actionHandler: { [weak self] status in
                            guard let `self` = self else { return }
                            self.event.me.status = status
                            self.view.update(with: EventDetailsViewModel(with: self.event))
                            self.changeStatus()
                    })
                )
            }
            view.itemSelected = { [weak self] item, delegate in
                guard self?.event.me.isOwner == true else { return }
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .small,
                    menuType: .eventMemberActions(group: .editing, actionHandler: { (actionType) in
                        switch actionType {
                        case .delete:
                            self?.removeMember(item.model)
                        case .makeOwner:
                            self?.takeOwnerRulesToMember(item.model)
                        }
                    })
                )
            }
            view.editAction = { [weak self] in
                guard let `self` = self else { return }
                self.view.updateState(with: EventDetailsStateViewModel(state: .edit, event: self.event), animated: true)
            }
            view.cancelAction = { [weak self] in
                guard let `self` = self else { return }
                self.view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
            }
            view.deleteAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.showAlert(
                    withMessage: R.string.localizable.eventDetailsDeleteAlertTitle(),
                    actions: [Action(title: R.string.localizable.commonDelete(), handler: { [weak self] in
                        self?.deleteEvent()
                    })]
                )
            }
            view.changeGameAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.openGameSearch(offtenGames: nil, selectedGame: self.event.game) { [weak self] newGame in
                    self?.changeGame(newGame)
                }
            }
            view.changeDateAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.showCarousel(configuration: .init(type: .change, date: self.event.date)) { [weak self] (newDate) in
                    self?.changeDate(newDate)
                }
            }
            view.addMemberAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.openMembersSearch(
                    eventId: self.event.id,
                    offtenMembers: nil,
                    selectedMembers: self.event.members) { [weak self] (newMembers) in
                        self?.addMembers(newMembers)
                    }
            }
        }
    }
    var interactor: EventDetailsInteractorInput!
    var router: EventDetailsRouterInput!
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchEvent),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    
    private var dataSource: MemoryStorage!
    private var event: Event! {
        didSet {
            guard let event = event else { return }
            self.members = event.members.sorted(by: { $0.name < $1.name }).sorted(by: { $0.isOwner == true && $1.isOwner != true})
        }
    }
    private var members: [User]!
    
    @objc private func fetchEvent() {
        interactor.fetchEvent(id: self.event.id) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let event):
                self.event = event
                self.view.update(with: EventDetailsViewModel(with: self.event))
                self.dataSource.setItems(self.members.map { EventDetailsCellViewModel(with: $0, event: self.event)})
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func changeStatus() {
        interactor.changeStatus(for: self.event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success: break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func changeGame(_ game: Game) {
        event.game = game
        interactor.changeGame(game, forEvent: event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                // TODO: Show success banner
                break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
    }
    
    private func changeDate(_ date: Date) {
        guard date != event.date else { return }
        event.date = date
        interactor.changeDate(date, forEvent: event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                // TODO: Show success banner
                break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
    }
    
    private func addMembers(_ members: [User]) {
        event.members.append(contentsOf: members)
        interactor.addMembers(members, toEvent: event) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                // TODO: Show success banner
                break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
    }
    
    private func removeMember(_ member: User) {
        interactor.removeMember(member, fromEvent: event) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                // TODO: Show success banner
                break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        event.members = event.members.filter({ $0.id != member.id })
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
    }
    
    private func takeOwnerRulesToMember(_ member: User) {
        if let index = event.members.firstIndex(of: member) {
            event.members[index].isOwner = true
        }
        interactor.takeOwnerRulesToMember(member, forEvent: event) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success:
                // TODO: Show success banner
                break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        event.me.isOwner = false
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, event: self.event), animated: true)
    }
    
    private func deleteEvent() {
        view.showProgress(indicatorType: .arrows, fullScreen: true)
        interactor.deleteEvent(event) { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success:
                self.router.close(animated: true)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - EventDetailsModuleInput

extension EventDetailsPresenter: EventDetailsModuleInput {

    func configure(with event: Event) {
        self.event = event
    }
}
