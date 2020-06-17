//
//  AuthorizationRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import LightRoute

final class AuthorizationRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - AuthorizationRouterInput

extension AuthorizationRouter: AuthorizationRouterInput {

    func openRegistration(with email: String?) {
        try? transitionHandler.forStoryboard(
            factory: StoryboardFactory(storyboard: R.storyboard.registration()),
            to: RegistrationModuleInput.self
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
}