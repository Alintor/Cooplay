//
//  UITextField.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UITextField {
    
    @IBInspectable var localizedPlaceholderKey: String {
        get {
            return ""
        }
        set {
            placeholder = NSLocalizedString(newValue, tableName: localizableUITableName, comment: "")
        }
    }
    
    @IBInspectable var localizedTextKey: String {
        get {
            return ""
        }
        set {
            text = NSLocalizedString(newValue, tableName: localizableUITableName, comment: "")
        }
    }
    
    @IBInspectable var aPlaceholderColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(
                NSAttributedString.Key.foregroundColor,
                at: 0,
                effectiveRange: nil
                )
                as? UIColor
        }
        set {
            guard
                let placeholder = placeholder,
                let placeholderColor = newValue else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
}
