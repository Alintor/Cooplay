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
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                guard let `self` = self else { return }
                self.dataSource = dataSource
                self.dataSource.setItems(self.members.map { EventDetailsCellViewModel(with: $0) })
            }
            view.statusAction = { [weak self] delegate in
                self?.router.showContextMenu(
                    delegate: delegate,
                    contextType: .overTarget,
                    menuSize: .large,
                    menuType: .statuses(type: .confirmation, actionHandler: { status in
                        guard let `self` = self else { return }
                        self.event.me.status = status
                        self.view.update(with: EventDetailsViewModel(with: self.event))
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
        }
    }
    var interactor: EventDetailsInteractorInput!
    var router: EventDetailsRouterInput!
    
    // MARK: - Private
    
    private var dataSource: MemoryStorage!
    private var event: Event! {
        didSet {
            guard let event = event else { return }
            self.members = event.members.sorted(by: { $0.name < $1.name }).sorted(by: { $0.isOwner == true || $1.isOwner == true})
        }
    }
    private var members: [User]!
}

// MARK: - EventDetailsModuleInput

extension EventDetailsPresenter: EventDetailsModuleInput {

    func configure(with event: Event) {
        self.event = event
    }
}
