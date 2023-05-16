//
//  PersonalisationRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit

final class PersonalisationRouter {

    internal weak var rootViewController: UIViewController?
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
}

// MARK: - PersonalisationRouterInput

extension PersonalisationRouter: PersonalisationRouterInput {

}
