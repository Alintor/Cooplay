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
        let alert = UIAlertController(
            title: R.string.localizable.profileSettingsLogoutMessage(),
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.view.tintColor = R.color.actionAccent()
        let logoutAction = UIAlertAction(
            title: R.string.localizable.profileSettingsLogoutActionButton(),
            style: .default
        ) { _ in
            completion()
        }
        logoutAction.setValue(R.color.red(), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel)
        


        // Accessing buttons tintcolor :
//alert.view.tintColor = UIColor.white

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        transitionHandler.present(alert, animated: true, completion:  nil)
    }
    
    func openReactionsSettings() {
        guard let rootController = transitionHandler as? UIViewController else { return }
        
        rootController.push(ReactionsSettingsBuilder().build())
    }
    
    func openArkanoidGame() {
        guard let rootController = transitionHandler as? UIViewController else { return }
        
        let arkanoidVC = ArkanoidViewController()
        arkanoidVC.modalPresentationStyle = .fullScreen
        arkanoidVC.modalTransitionStyle = .crossDissolve
        rootController.present(arkanoidVC, animated: true)
    }
}
