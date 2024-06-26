//
//  UINavigationItem.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    @IBInspectable var localizedKey: String {
        get {
            return ""
        }
        set {
            title = NSLocalizedString(newValue, tableName: localizableUITableName, comment: "")
        }
    }
}
