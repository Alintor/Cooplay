//
//  UISearchBar.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    @IBInspectable var localizedPlaceholderKey: String {
        get {
            return ""
        }
        set {
            placeholder = NSLocalizedString(newValue, tableName: localizableUITableName, comment: "")
        }
    }
}
