//
//  EventsListRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import UIKit

final class EventsListRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - EventsListRouterInput

extension EventsListRouter: EventsListRouterInput {

    func openEvent(_ event: Event) {
        let eventDetailsViewController = EventDetailsBuilder().build(with: event)
        
        rootViewController?.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func openNewEvent() {
        rootViewController?.push(NewEventBuilder().build())
    }
    
    func openProfile(with user: Profile) {
        let profileViewController = ProfileBuilder().build(with: user)
        let navigationController = UINavigationController(rootViewController: profileViewController)
        
        rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
