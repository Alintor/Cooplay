//
//  EventDetailsRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import UIKit

final class EventDetailsRouter {

    weak var rootViewController: UIViewController?
}

// MARK: - EventDetailsRouterInput

extension EventDetailsRouter: EventDetailsRouterInput {

    func openMembersSearch(
        eventId: String,
        offtenMembers: [User]?,
        selectedMembers: [User],
        selectionHandler: ((_ members: [User]) -> Void)?
    ) {
        let navigationController = UINavigationController(rootViewController: SearchMembersBuilder().build(
            eventId: eventId,
            offtenMembers: offtenMembers,
            selectedMembers: selectedMembers,
            isEditing: true,
            selectionHandler: selectionHandler
        ))
        rootViewController?.presentModally(navigationController)
    }
    
    func showReactionMenu(delegate: ReactionContextMenuDelegate?, currentReaction: Reaction?, handler: ((_ reaction: Reaction?) -> Void)?) {
        let reactionMenuView = ReactionContextMenuView(delegate: delegate, selectedReaction: currentReaction, handler: handler)
        reactionMenuView.show()
    }
}
