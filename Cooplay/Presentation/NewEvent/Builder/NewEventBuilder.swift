//
//  NewEventBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class NewEventBuilder {
    
    func build(closeHandler: (() -> Void)? = nil) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.newEvent.newEventViewController()!
        let interactor = NewEventInteractor(
            eventService: r.resolve(EventServiceType.self),
            userService: r.resolve(UserServiceType.self)
        )
        let router = NewEventRouter(rootViewController: viewController)
        let presenter = NewEventPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        viewController.output = presenter
        presenter.configure(closeHandler: closeHandler)
        
        return viewController
    }
}
