//
//  PersonalisationBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class PersonalisationBuilder {
    
    func build(user: User) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.personalisation.personalisationViewController()!
        let interactor = PersonalisationInteractor(userService: r.resolve(UserServiceType.self))
        let router = PersonalisationRouter(rootViewController: viewController)
        let presenter = PersonalisationPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        presenter.configure(with: user)
        viewController.output = presenter
        
        return viewController
    }
}
