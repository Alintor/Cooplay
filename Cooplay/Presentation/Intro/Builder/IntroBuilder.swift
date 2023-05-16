//
//  IntroBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class IntroBuilder {
    
    func build() -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.intro.introViewController()!
        let interactor = IntroInteractor()
        let router = IntroRouter(rootViewController: viewController)
        let presenter = IntroPresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        viewController.output = presenter
        
        return viewController
    }
}
