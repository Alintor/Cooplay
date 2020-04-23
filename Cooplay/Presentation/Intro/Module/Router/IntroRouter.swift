//
//  IntroRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import LightRoute

final class IntroRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - IntroRouterInput

extension IntroRouter: IntroRouterInput {

    func openAuthorization() {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.authorization()),
            to: AuthorizationModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .perform()
    }
    
    func openRegistration() {
        
    }
}
