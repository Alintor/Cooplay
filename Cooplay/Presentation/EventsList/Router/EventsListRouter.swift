//
//  EventsListRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import UIKit
import SwiftUI

final class EventsListRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - EventsListRouterInput

extension EventsListRouter: EventsListRouterInput {

    func openEvent(_ event: Event) {
//        let eventDetailsViewController = EventDetailsBuilder().build(with: event)
//        
//        rootViewController?.navigationController?.pushViewController(eventDetailsViewController, animated: true)
    }
    
    func openNewEvent() {
        rootViewController?.push(NewEventBuilder().build())
    }
    
    func openProfile(with user: Profile) {
        rootViewController?.present(UIHostingController(rootView: ScreenViewFactory.profile(user)), animated: true, completion: nil)
    }
}
