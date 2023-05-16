//
//  NewEventRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import UIKit

final class NewEventRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - NewEventRouterInput

extension NewEventRouter: NewEventRouterInput {

    func showCalendar(selectedDate: Date?, handler: ((_ date: Date) -> Void)?) {
        let calendarRenderer = CalendarViewRenderer()
        calendarRenderer.show(selectedDate: selectedDate, handler: handler)
    }
    
    func openMembersSearch(eventId: String, offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?) {
        let searchMembersViewController = SearchMembersBuilder().build(
            eventId: eventId,
            offtenMembers: offtenMembers,
            selectedMembers: selectedMembers,
            isEditing: false,
            selectionHandler: selectionHandler
        )
        let navigationController = UINavigationController(rootViewController: searchMembersViewController)
        rootViewController?.presentModally(navigationController)
    }
}
