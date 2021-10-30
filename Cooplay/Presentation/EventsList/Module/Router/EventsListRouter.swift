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
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.eventDetails()),
            to: EventDetailsModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .then { moduleInput in
            moduleInput.configure(with: event)
        }
    }
    
    func openNewEvent() {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.newEvent()),
            to: NewEventModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .perform()
    }
    
    func openProfile(with user: User) {
//        try? transitionHandler.forStoryboard(
//            factory: StoryboardFactory(storyboard: R.storyboard.profile()),
//            to: ProfileModuleInput.self
//        )
//        .to(preferred: .navigation(style: .push))
//        .perform()
        
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        
        let profileViewController = ProfileViewCOnrtollerBuilder.build(with: user)
        
        transitionHandler.present(profileViewController, animated: true, completion: nil)
    }
}
