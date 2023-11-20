//
//  RegistrationBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class RegistrationBuilder {
    
    func build(email: String?) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.registration.registrationViewController()!
        let interactor = RegistrationInteractor(
            authorizationService: r.resolve(AuthorizationServiceType.self)
        )
        let router = RegistrationRouter(rootViewController: viewController)
        let presenter = RegistrationPresenter(
            view: viewController,
            interactor: interactor,
            router: router, 
            store: ApplicationFactory.getStore()
        )
        presenter.configure(with: email)
        viewController.output = presenter
        
        return viewController
    }
}

