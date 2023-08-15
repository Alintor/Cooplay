//
//  EventDetailsBuilder.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI
import Swinject

class EventDetailsBuilder {
    
    func build(with event: Event) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let interactor = EventDetailsInteractor(
            eventService: r.resolve(EventServiceType.self)!,
            defaultsStorage: r.resolve(DefaultsStorageType.self)!
        )
        let router = EventDetailsRouter()
        let viewModel = EventDetailsViewModel(with: event)
        let presenter = EventDetailsPresenter(viewModel: viewModel, interactor: interactor, router: router)
        
        let viewController = EventDetailsViewController(
            contentView: EventDetailsView(viewModel: viewModel, output: presenter),
            output: presenter
        )
        router.rootViewController = viewController
        
        return viewController
    }
}
