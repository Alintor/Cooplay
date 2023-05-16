//
//  EventDetailsRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Foundation

protocol EventDetailsRouterInput:
    ContextMenuRouter,
    TimePickerRoutable,
    SearchGameRoutable,
    TimeCarouselRoutable,
    PopupRoutable,
    CloseableRouter {

    func openMembersSearch(eventId: String, offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?)
    func showReactionMenu(delegate: ReactionContextMenuDelegate?, currentReaction: Reaction?, handler: ((_ reaction: Reaction?) -> Void)?)
}
