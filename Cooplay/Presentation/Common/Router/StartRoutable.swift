//
//  StartRoutable.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/05/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol StartRoutable: Router {
    
    func openEventList()
}

extension StartRoutable {
    
    func openEventList() {
        transitionHandler.setRootViewController(
            UINavigationController(rootViewController: R.storyboard.eventsList.eventsListViewController()!)
        )
    }
}

