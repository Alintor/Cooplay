//
//  AppearanceApplicationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import PluggableAppDelegate

final class AppearanceApplicationService: NSObject, ApplicationService {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let navigationBarAppearance = UINavigationBar.appearance()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = .clear
            //appearance.backgroundColor = R.color.background()
            appearance.backgroundColor = .clear
            appearance.shadowImage = UIImage()
            appearance.titleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            appearance.largeTitleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            navigationBarAppearance.standardAppearance = appearance
            navigationBarAppearance.compactAppearance = appearance
            navigationBarAppearance.scrollEdgeAppearance = appearance
        } else {
            navigationBarAppearance.setBackgroundImage(UIImage(), for: .default)
            navigationBarAppearance.barStyle = .blackOpaque
//            navigationBarAppearance.barTintColor = R.color.background()
//            navigationBarAppearance.isTranslucent = false
            navigationBarAppearance.barTintColor = .clear
            navigationBarAppearance.isTranslucent = true
            navigationBarAppearance.shadowImage = UIImage()
            navigationBarAppearance.titleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
            navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: R.color.textPrimary()!]
        }
        
        navigationBarAppearance.tintColor = R.color.actionAccent()
        return true
    }
}
