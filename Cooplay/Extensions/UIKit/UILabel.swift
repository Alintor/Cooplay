//
//  UILabel.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UILabel {
    
    @IBInspectable var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: localizableUITableName, comment: "")
        }
    }
}
