//
//  Constants.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

enum GlobalConstant {
    
    enum Format {
        
        enum Date: String {
            case serverDate = "yyyy-MM-dd HH:mm:ss",
            time = "HH:mm"
        }
    }
    
    static var screenWidth: CGFloat = UIApplication.shared.statusBarFrame.size.width
    static var isSmallScreen: Bool {
        return screenWidth < 370.0
    }
}

var localizableUITableName = "Localizable"
