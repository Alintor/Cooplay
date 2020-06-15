//
//  UITextField.swift
//  Cooplay
//
//  Created by Alexandr on 16/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UITextField {
    
    enum FieldState {
        case normal
        case error
        case highlighted
        case correct
        
        var color: CGColor? {
            switch self {
            case .normal:
                return R.color.shapeBackground()?.cgColor
            case .error:
                return R.color.red()?.cgColor
            case .highlighted:
                return R.color.actionAccent()?.cgColor
            case .correct:
                return R.color.green()?.cgColor
            }
        }
    }
    
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
    
    func setPaddingPoints(left: CGFloat, right: CGFloat) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    func setState(_ state: FieldState) {
        self.layer.borderColor = state.color
    }
}
