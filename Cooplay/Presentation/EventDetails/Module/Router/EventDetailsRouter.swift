//
//  EventDetailsRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import LightRoute

final class EventDetailsRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - EventDetailsRouterInput

extension EventDetailsRouter: EventDetailsRouterInput {

    func openMembersSearch(eventId: String, offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let searchMembersViewController = R.storyboard.searchMembers.searchMembersViewController()!
        searchMembersViewController.output?.configure(
            eventId: eventId,
            offtenMembers: offtenMembers,
            selectedMembers: selectedMembers,
            isEditing: true,
            selectionHandler: selectionHandler
        )
        let navigationController = UINavigationController(rootViewController: searchMembersViewController)
        transitionHandler.present(navigationController, animated: true, completion: nil)
    }
    
    func showReactionMenu(delegate: ReactionContextMenuDelegate?, currentReaction: Reaction?, handler: ((_ reaction: Reaction?) -> Void)?) {
        let reactionMenuView = ReactionContextMenuView(delegate: delegate, selectedReaction: currentReaction, handler: handler)
        reactionMenuView.show()
    }
}
