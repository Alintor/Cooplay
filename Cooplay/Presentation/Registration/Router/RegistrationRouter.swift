//
//  RegistrationRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import UIKit

final class RegistrationRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - RegistrationRouterInput

extension RegistrationRouter: RegistrationRouterInput {

    func openAuthorization(with email: String?) {
        rootViewController?.push(AuthorizationBuilder().build(email: email))
    }
    
    func clearNavigationStack() {
        var navigationStack = rootViewController?.navigationController?.viewControllers
        guard navigationStack?[1] != rootViewController else { return }
        
        navigationStack?.remove(at: 1)
        navigationStack.map { rootViewController?.navigationController?.viewControllers = $0 }
    }
    
    func openPersonalisation(with user: User) {
        rootViewController?.push(PersonalisationBuilder().build(user: user))
    }
}
