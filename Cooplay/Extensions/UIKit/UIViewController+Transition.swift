//
//  UIViewController+Transition.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentModally(
        _ controller: UIViewController,
        completion: (() -> Void)? = nil
    ) {
        present(controller, animated: true, completion: completion)
    }
    
    func push(
        _ controller: UIViewController
    ) {
        navigationController?.pushViewController(
            controller,
            animated: true
        )
    }
    
    func close(_ animated: Bool = true) {
        if let navigationController = self.parent as? UINavigationController {
            if navigationController.children.count > 1 {
                guard let controller = navigationController.children.dropLast().last else { return }
                navigationController.popToViewController(controller, animated: animated)
            } else {
                dismiss(animated: animated, completion: nil)
            }
        } else if presentingViewController != nil {
            dismiss(animated: animated, completion: nil)
        }
    }
    
    func popToRoot() {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setRootViewController(_ viewController: UIViewController?) {
        UIApplication.setRootViewController(viewController)
    }
    
}
