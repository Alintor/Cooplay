//
//  AuthorizationRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class AuthorizationRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - AuthorizationRouterInput

extension AuthorizationRouter: AuthorizationRouterInput {

    func openRegistration(with email: String?) {
        rootViewController?.push(RegistrationBuilder().build(email: email))
    }
    
    func clearNavigationStack() {
        var navigationStack = rootViewController?.navigationController?.viewControllers
        guard navigationStack?[1] != rootViewController else { return }
        
        navigationStack?.remove(at: 1)
        navigationStack.map { rootViewController?.navigationController?.viewControllers = $0 }
    }
}
