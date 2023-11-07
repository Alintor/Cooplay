//
//  EditProfileBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class EditProfileBuilder {
    
    func build(profile: Profile) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewModel = EditProfileViewModel(profile: profile)
        let interactor = EditProfileInteractor(userService: r.resolve(UserServiceType.self)!)
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(
            view: viewModel,
            interactor: interactor,
            router: router
        )
        interactor.output = presenter
        let viewController = EditProfileViewController(
            contentView: EditProfileOldView(viewModel: viewModel, output: presenter),
            output: presenter
        )
        router.rootViewController = viewController
        
        return viewController
    }
}
