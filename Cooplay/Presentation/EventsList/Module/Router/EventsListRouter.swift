//
//  EventsListRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import LightRoute

final class EventsListRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - EventsListRouterInput

extension EventsListRouter: EventsListRouterInput {

    func openEvent(_ event: Event) {
//        try? transitionHandler.forStoryboard(
//            factory: StoryboardFactory(storyboard: R.storyboard.eventDetails()),
//            to: EventDetailsModuleInput.self
//        )
//        .to(preferred: .navigation(style: .push))
//        .then { moduleInput in
//            moduleInput.configure(with: event)
//        }
        
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        
        let eventDetailsViewController = EventDetailsBuilder().build(with: event)
        
        transitionHandler.navigationController?.pushViewController(eventDetailsViewController, animated: true)
        //transitionHandler.present(eventDetailsViewController, animated: true, completion: nil)
    }
    
    func openNewEvent() {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.newEvent()),
            to: NewEventModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .perform()
    }
    
    func openProfile(with user: Profile) {
//        try? transitionHandler.forStoryboard(
//            factory: StoryboardFactory(storyboard: R.storyboard.profile()),
//            to: ProfileModuleInput.self
//        )
//        .to(preferred: .navigation(style: .push))
//        .perform()
        
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        
        let profileViewController = ProfileBuilder().build(with: user)
        let navigationController = UINavigationController(rootViewController: profileViewController)
        
        transitionHandler.present(navigationController, animated: true, completion: nil)
    }
}
