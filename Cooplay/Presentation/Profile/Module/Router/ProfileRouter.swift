//
//  ProfileRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import LightRoute

final class ProfileRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {

    func showLogoutAlert(completion: @escaping () -> Void) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let alert = UIAlertController(title: "Вы уверены, что хотите выйти из аккаунта?", message: nil, preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Выйти из аккаунта", style: .default) { _ in
            completion()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        


        // Accessing buttons tintcolor :
//alert.view.tintColor = UIColor.white

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        transitionHandler.present(alert, animated: true, completion:  nil)
    }
}
