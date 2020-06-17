//
//  StartModuleApplicationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard
import PluggableAppDelegate
import Firebase

final class InitialModuleApplicationService: NSObject, ApplicationService {
    
    private var container: Container? {
        return ApplicationAssembly.assembler.resolver as? Container
    }
    //private lazy var authorizationService = container!.resolve(AuthorizationNetworkService.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupInitialModule()
        firstLaunchSetup()
        return true
    }
    
    // MARK: - Private
    
    private func setupInitialModule() {
        UIApplication.setRootViewController(UINavigationController(
            rootViewController: R.storyboard.intro.introViewController()!
        ))
    }
    
    private func firstLaunchSetup() {
//        let defaultsStorage = container?.resolve(DefaultsStorageType.self)
//        if
//            let firstLaunchDate = defaultsStorage?.get(
//                valueForKey: DefaultsStorage.Key.firstLaunchDate) as? TimeInterval,
//            firstLaunchDate > 0 { return }
//        defaultsStorage?.set(value: Date().timeIntervalSince1970, forKey: DefaultsStorage.Key.firstLaunchDate)
    }
}

