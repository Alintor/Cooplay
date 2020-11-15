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
                self.view.updateState(with: EventDetailsStateViewModel(state: .normal, isOwner: self.event.me.isOwner), animated: false)
                self.fetchEvent()
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                guard let `self` = self else { return }
                self.dataSource = dataSource
                self.dataSource.setItems(self.members.map { EventDetailsCellViewModel(with: $0) })
            }
            view.statusAction = { [weak self] delegate in
                guard let `self` = self else { return }
                self.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .large,
                    menuType: .statuses(
                        type: self.event.isActive ? .confirmation : .agreement,
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
                    menuType: .eventMemberActions(actionHandler: { (actionType) in
                        // TODO:
                    })
                )
            }
            view.editAction = { [weak self] in
                guard let `self` = self else { return }
                self.view.updateState(with: EventDetailsStateViewModel(state: .edit, isOwner: self.event.me.isOwner), animated: true)
            }
            view.cancelAction = { [weak self] in
                guard let `self` = self else { return }
                self.view.updateState(with: EventDetailsStateViewModel(state: .normal, isOwner: self.event.me.isOwner), animated: true)
            }
            view.deleteAction = { [weak self] in
                guard let `self` = self else { return }
            }
            view.changeGameAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.openGameSearch(offtenGames: nil) { [weak self] newGame in
                    self?.changeGame(newGame)
                }
            }
            view.changeDateAction = { [weak self] in
                guard let `self` = self else { return }
                //self.router.showTimePicker(startTime: self.event.date, enableMinimumTime: true, showDate: true, handler: nil)
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
                self.dataSource.setItems(self.members.map { EventDetailsCellViewModel(with: $0)})
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
        interactor.changeGame(game, forEvent: event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success: break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
        event.game = game
        view.update(with: EventDetailsViewModel(with: self.event))
        view.updateState(with: EventDetailsStateViewModel(state: .normal, isOwner: self.event.me.isOwner), animated: true)
    }
}

// MARK: - EventDetailsModuleInput

extension EventDetailsPresenter: EventDetailsModuleInput {

    func configure(with event: Event) {
        self.event = event
    }
}
