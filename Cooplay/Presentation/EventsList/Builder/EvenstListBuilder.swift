//
//  EventListBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class EventsListBuilder {
    
    func build() -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.eventsList.eventsListViewController()!
        let interactor = EventsListInteractor(
            eventService: r.resolve(EventServiceType.self),
            userService: r.resolve(UserServiceType.self),
            defaultsStorage: r.resolve(DefaultsStorageType.self)
        )
        let router = EventsListRouter(rootViewController: viewController)
        let presenter = EventsListPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        viewController.output = presenter
        
        return viewController
    }
}
