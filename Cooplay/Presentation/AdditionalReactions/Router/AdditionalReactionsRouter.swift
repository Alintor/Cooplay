//
//  AdditionalReactionsRouter.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit

final class AdditionalReactionsRouter {
    
    weak var rootController: UIViewController?
}

extension AdditionalReactionsRouter: AdditionalReactionsRouterInput {
    
    func close(withImpact: Bool) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        rootController?.dismiss(animated: true, completion: {
            if withImpact {
                generator.impactOccurred()
            }
        })
    }
}
