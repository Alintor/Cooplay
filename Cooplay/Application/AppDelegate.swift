//
//  AppDelegate.swift
//  Cooplay
//
//  Created by Alexandr on 19/09/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit
import PluggableAppDelegate

@UIApplicationMain
final class AppDelegate: PluggableApplicationDelegate {
    
    override var services: [ApplicationService] {
        return [
            AppearanceApplicationService(),
            StartModuleApplicationService()
        ]
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

