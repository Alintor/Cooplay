//
//  KeyboardHandler.swift
//  Cooplay
//
//  Created by Alexandr on 05/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

public protocol KeyboardHandler: class {
    
    var keyboardWillShowObserver: NSObjectProtocol? { get set }
    var keyboardWillHideObserver: NSObjectProtocol? { get set }
    
    func registerForKeyboardEvents()
    func unregisterFromKeyboardEvents()
    func keyboardWillShow(keyboardHeight: CGFloat, duration: TimeInterval)
    func keyboardWillHide(keyboardHeight: CGFloat, duration: TimeInterval)
    
}

public extension KeyboardHandler where Self: UIViewController {
    
    func registerForKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        keyboardWillShowObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard
                let `self` = self,
                let userInfo = notification.userInfo,
                var keyboardHeight =
                    (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
                let duration: TimeInterval =
                    (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            else { return }
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom
            }
            self.keyboardWillShow(keyboardHeight: keyboardHeight, duration: duration)
        }
        keyboardWillHideObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard
                let `self` = self,
                let userInfo = notification.userInfo,
                var keyboardHeight =
                    (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
                let duration: TimeInterval =
                    (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
                else { return }
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardHeight - self.view.safeAreaInsets.bottom
            }
            self.keyboardWillHide(keyboardHeight: keyboardHeight, duration: duration)
        }
    }
    
    func unregisterFromKeyboardEvents() {
        let notificationCenter = NotificationCenter.default
        if let keyboardWillShowObserver = keyboardWillShowObserver {
            notificationCenter.removeObserver(keyboardWillShowObserver)
        }
        if let keyboardWillHideObserver = keyboardWillHideObserver {
            notificationCenter.removeObserver(keyboardWillHideObserver)
        }
    }
}
