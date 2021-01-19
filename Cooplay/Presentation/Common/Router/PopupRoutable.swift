//
//  PopupRoutable.swift
//  Cooplay
//
//  Created by Alexandr on 19/01/2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import LightRoute

struct Action {
    
    let title: String
    let handler: (() -> Void)?
}

protocol PopupRoutable: Router {
    
}

extension PopupRoutable {
    
    func showAlert(
        withMessage message: String,
        title: String? = nil,
        style: UIAlertController.Style = .alert,
        cancelTitle: String = R.string.localizable.commonCancel(),
        actions: [Action] = [],
        closeHandler: (() -> Void)? = nil) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.view.tintColor = R.color.actionAccent()
        if #available(iOS 13.0, *) {
            alert.overrideUserInterfaceStyle = .dark
        }
        for action in actions {
            alert.addAction(UIAlertAction(title: action.title, style: .default) { _ in
                action.handler?()
                closeHandler?()
            })
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            closeHandler?()
        })
        DispatchQueue.main.async {
            transitionHandler.present(alert, animated: true, completion: nil)
        }
    }
}
