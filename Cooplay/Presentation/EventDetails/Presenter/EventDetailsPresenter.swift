//
//  EventDetailsPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import DTModelStorage

final class EventDetailsPresenter {

    
    private let interactor: EventDetailsInteractorInput
    private let router: EventDetailsRouterInput
    private let viewModel: EventDetailsViewInput
    
    init(
        viewModel: EventDetailsViewInput,
        interactor: EventDetailsInteractorInput,
        router: EventDetailsRouterInput
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
        self.router = router
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
    
    
    @objc private func fetchEvent() {
        interactor.fetchEvent(id: self.viewModel.event.id) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let event):
                self.viewModel.update(with: event)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func changeStatus() {
        interactor.changeStatus(for: viewModel.event) { [weak self] result in
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
        viewModel.updateGame(game)
        interactor.changeGame(game, forEvent: viewModel.event) { [weak self] result in
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
        viewModel.changeEditMode()
    }
    
    private func changeDate(_ date: Date) {
        guard date != viewModel.event.date else { return }
        viewModel.updateDate(date)
        interactor.changeDate(date, forEvent: viewModel.event) { [weak self] result in
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
        viewModel.changeEditMode()
    }
    
    private func addMembers(_ newMembers: [User]) {
        var members = viewModel.event.members
        members.append(contentsOf: newMembers)
        viewModel.updateMembers(members)
        interactor.addMembers(newMembers, toEvent: viewModel.event) { [weak self] (result) in
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
        viewModel.changeEditMode()
    }
    
    private func removeMember(_ member: User) {
        interactor.removeMember(member, fromEvent: viewModel.event) { [weak self] (result) in
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
        viewModel.updateMembers(viewModel.event.members.filter({ $0.id != member.id }))
        //viewModel.changeEditMode()
    }
    
    private func takeOwnerRulesToMember(_ member: User) {
        interactor.takeOwnerRulesToMember(member, forEvent: viewModel.event) { [weak self] (result) in
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
        if let index = viewModel.event.members.firstIndex(of: member) {
            viewModel.takeOwnerRulesToMemberAtIndex(index)
        }
        //viewModel.changeEditMode()
    }
    
    private func deleteEvent() {
        interactor.deleteEvent(viewModel.event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success:
                self.router.close(animated: true)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func addReaction(_ reaction: Reaction?, to member: User) {
        interactor.addReaction(reaction, to: member, for: viewModel.event) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success: break
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
}



extension EventDetailsPresenter: EventDetailsViewOutput {
    
    func didLoad() {
        self.fetchEvent()
    }
    
    func statusAction(with delegate: StatusContextDelegate) {
        let oldStatus = viewModel.event.me.status
        self.router.showContextMenu(
            delegate: delegate,
            contextType: .overTarget,
            menuSize: .large,
            menuType: .statuses(
                type: viewModel.event.statusesType,
                event: viewModel.event,
                actionHandler: { [weak self] status in
                    guard let `self` = self, oldStatus != status else { return }
                    self.changeStatus()
            })
        )
    }
    
    func itemSelected(_ member: User, delegate: StatusContextDelegate) {
        guard viewModel.event.me.isOwner == true else { return }
        self.router.showContextMenu(
            delegate: delegate,
            contextType: .overTarget,
            menuSize: .small,
            menuType: .eventMemberActions(group: .editing, actionHandler: { [weak self] (actionType) in
                switch actionType {
                case .delete:
                    self?.removeMember(member)
                case .makeOwner:
                    self?.takeOwnerRulesToMember(member)
                }
            })
        )
    }
    
    func deleteAction() {
        self.router.showAlert(
            withMessage: R.string.localizable.eventDetailsDeleteAlertTitle(),
            actions: [Action(title: R.string.localizable.commonDelete(), handler: { [weak self] in
                self?.deleteEvent()
            })]
        )
    }
    
    func changeGameAction() {
        self.router.openGameSearch(offtenGames: nil, selectedGame: viewModel.event.game) { [weak self] newGame in
            self?.changeGame(newGame)
        }
    }
    
    func changeDateAction(delegate: TimeCarouselContextDelegate) {
        self.router.showCarousel(delegate: delegate, configuration: .init(type: .change, date: viewModel.event.date)) { [weak self] (newDate) in
            self?.changeDate(newDate)
        }
    }
    
    func addMemberAction() {
        self.router.openMembersSearch(
            eventId: viewModel.event.id,
            offtenMembers: nil,
            selectedMembers: viewModel.event.members
        ) { [weak self] (newMembers) in
                self?.addMembers(newMembers)
        }
    }
    
    func reactionTapped(for member: User, delegate: ReactionContextMenuDelegate?) {
        router.showReactionMenu(
            delegate: delegate,
            currentReaction: viewModel.currentReaction(to: member)
        ) { [weak self] reaction in
            self?.viewModel.addReaction(reaction,to: member)
            self?.addReaction(reaction, to: self?.viewModel.getActualMemberInfo(member) ?? member)
        }
    }
    
}
