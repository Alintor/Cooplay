//
//  RegistrationRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import LightRoute

final class RegistrationRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {

    func openAuthorization(with email: String?) {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.authorization()),
            to: AuthorizationModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .then({ $0.configure(with: email) })
    }
    
    func clearNavigationStack() {
        guard let viewController = transitionHandler as? UIViewController else { return }
        var navigationStack = viewController.navigationController?.viewControllers
        guard navigationStack?[1] != viewController else { return }
        navigationStack?.remove(at: 1)
        navigationStack.map { viewController.navigationController?.viewControllers = $0 }
    }
    
    func openPersonalisation(with user: User) {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.personalisation()),
            to: PersonalisationModuleInput.self
        )
        .to(preferred: .navigation(style: .push))
        .then({ $0.configure(with: user) })
    }
}
