//
//  AuthorizationBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class AuthorizationBuilder {
    
    func build(email: String?) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.authorization.authorizationViewController()!
        let interactor = AuthorizationInteractor(
            authorizationService: r.resolve(AuthorizationServiceType.self)
        )
        let router = AuthorizationRouter(rootViewController: viewController)
        let presenter = AuthorizationPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        presenter.configure(with: email)
        viewController.output = presenter
        
        return viewController
    }
}
