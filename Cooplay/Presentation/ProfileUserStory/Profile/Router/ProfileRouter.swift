//
//  ProfileRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import UIKit
import SwiftUI

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
        cancelAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        rootViewController?.present(alert, animated: true, completion:  nil)
    }
    
    func openReactionsSettings() {
        //rootViewController?.push(ReactionsSettingsBuilder().build())
    }
    
    func openArkanoidGame() {
        let arkanoidVC = ArkanoidViewController()
        arkanoidVC.modalPresentationStyle = .fullScreen
        arkanoidVC.modalTransitionStyle = .crossDissolve
        rootViewController?.present(arkanoidVC, animated: true)
    }
    
    func openEdit(profile: Profile) {
        rootViewController?.push(UIHostingController(rootView: ScreenViewFactory.shared.editProfile(profile)))
    }
}
