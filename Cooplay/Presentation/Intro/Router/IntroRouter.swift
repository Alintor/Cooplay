//
//  IntroRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import UIKit

final class IntroRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - IntroRouterInput

extension IntroRouter: IntroRouterInput {

    func openAuthorization() {
        //rootViewController?.push(AuthorizationBuilder().build(email: nil))
    }
    
    func openRegistration() {
        rootViewController?.push(RegistrationBuilder().build(email: nil))
    }
}
