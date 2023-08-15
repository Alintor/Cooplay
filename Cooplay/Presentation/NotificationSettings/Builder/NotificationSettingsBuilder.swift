//
//  NotificationSettingsBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 01/08/2023.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

enum NotificationSettingsBuilder {
    
    static func build() -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver

        let viewModel = NotificationSettingsViewModel()
        let interactor = NotificationSettingsInteractor()
        let router = NotificationSettingsRouter()
        let presenter = NotificationSettingsPresenter(
            view: viewModel,
            interactor: interactor,
            router: router
        )
        let viewController = NotificationSettingsViewController(
            contentView: NotificationSettingsView(viewModel: viewModel, output: presenter),
            output: presenter
        )
        router.rootController = viewController
        
        return viewController
    }
}