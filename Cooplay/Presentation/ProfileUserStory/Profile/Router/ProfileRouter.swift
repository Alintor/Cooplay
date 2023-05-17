//
//  ProfileRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit

final class ProfileRouter {

    weak var rootViewController: UIViewController?
}

// MARK: - ProfileRouterInput

extension ProfileRouter: ProfileRouterInput {

    func showLogoutAlert(completion: @escaping () -> Void) {
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
        rootViewController?.present(alert, animated: true, completion:  nil)
    }
    
    func openReactionsSettings() {
        rootViewController?.push(ReactionsSettingsBuilder().build())
    }
    
    func openArkanoidGame() {
        let arkanoidVC = ArkanoidViewController()
        arkanoidVC.modalPresentationStyle = .fullScreen
        arkanoidVC.modalTransitionStyle = .crossDissolve
        rootViewController?.present(arkanoidVC, animated: true)
    }
    
    func openEdit(profile: Profile) {
        rootViewController?.push(EditProfileBuilder().build(profile: profile))
    }
}