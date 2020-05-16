//
//  UIApplication.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/05/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static func setRootViewController(_ viewController: UIViewController?) {
        UIApplication.shared.delegate?.window??.rootViewController = viewController
    }
}
