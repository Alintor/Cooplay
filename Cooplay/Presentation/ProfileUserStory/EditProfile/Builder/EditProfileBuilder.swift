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
    
    func build() -> UIViewController {
        let resolver = ApplicationAssembly.assembler.resolver
        let viewModel = EditProfileViewModel()
        let interactor = EditProfileInteractor()
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(
            view: viewModel,
            interactor: interactor,
            router: router
        )
        let viewController = EditProfileViewController(
            contentView: EditProfileView(viewModel: viewModel, output: presenter),
            output: presenter
        )
        router.rootController = viewController
        
        return viewController
    }
}
