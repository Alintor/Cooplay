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
    private lazy var authorizationService = container!.resolve(AuthorizationServiceType.self)!
    private lazy var userService = container!.resolve(UserServiceType.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        setupInitialModule()
        checkProficeExistanse()
        firstLaunchSetup()
        return true
    }
    
    // MARK: - Private
    
    private func setupInitialModule() {
        if authorizationService.isLoggedIn {
            UIApplication.setRootViewController(UINavigationController(
                rootViewController: R.storyboard.eventsList.eventsListViewController()!)
            )
        } else {
            UIApplication.setRootViewController(UINavigationController(
                rootViewController: R.storyboard.intro.introViewController()!
            ))
        }
    }
    
    private func checkProficeExistanse() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        userService.checkProfileExistanse { [weak self] (result) in
            switch result {
            case .success(let exist):
                guard let `self` = self, !exist else { return }
                let user = User(id: userId, name: nil, avatarPath: nil, state: .unknown, lateness: nil, isOwner: nil)
                // TODO:
                let personalisation = R.storyboard.personalisation.personalisationViewController()!
                personalisation.output?.configure(with: user)
                if #available(iOS 13.0, *) {
                    personalisation.isModalInPresentation = true
                }
                self.window?.rootViewController?.present(
                    UINavigationController(rootViewController: personalisation),
                    animated: true,
                    completion: nil
                )
            case .failure: break
            }
        }
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

