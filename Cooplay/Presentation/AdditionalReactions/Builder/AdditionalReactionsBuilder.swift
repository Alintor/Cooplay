//
//  AdditionalReactionsBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

//final class AdditionalReactionsBuilder {
//    
//    func build(selectedReaction: String?, handler: ((Reaction?) -> Void)?) -> UIViewController {
//        let resolver = ApplicationAssembly.assembler.resolver
//        let interactor = AdditionalReactionsInteractor(defaultsStorage: resolver.resolve(DefaultsStorageType.self)!)
//        let router = AdditionalReactionsRouter()
//        let presenter = AdditionalReactionsPresenter(
//            interactor: interactor,
//            router: router,
//            handler: handler
//        )
//        let viewController = UIHostingController(rootView: AdditionalReactionsView(
//            output: presenter,
//            selectedReaction: selectedReaction
//        ))
//        router.rootController = viewController
//        viewController.isModalInPresentation = false
//        
//        return viewController
//    }
//}
