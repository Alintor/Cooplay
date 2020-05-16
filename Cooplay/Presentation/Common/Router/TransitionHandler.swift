//
//  TransitionHandler.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/05/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import LightRoute

extension TransitionHandler {
    
    func setRootViewController(_ viewController: UIViewController?) {
        UIApplication.setRootViewController(viewController)
    }
}
