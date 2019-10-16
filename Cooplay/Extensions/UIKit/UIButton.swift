//
//  UIButton.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIButton {
    
    @IBInspectable var localizedTitleKey: String {
        get {
            return ""
        }
        set {
            setTitle(
                NSLocalizedString(
                    newValue,
                    tableName: localizableUITableName,
                    comment: ""
                ),
                for: .normal
            )
        }
    }
}
