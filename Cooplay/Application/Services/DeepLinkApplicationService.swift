//
//  DeepLinkApplicationService.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard
import PluggableAppDelegate
import Firebase

final class DeepLinkApplicationService: NSObject, ApplicationService {
    
    private var container: Container? {
        return ApplicationAssembly.assembler.resolver as? Container
    }
    private lazy var authorizationService = container!.resolve(AuthorizationServiceType.self)!
    private lazy var defaultsStorage = container!.resolve(DefaultsStorageType.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if let url = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] {
//            let calendarRenderer = CalendarViewRenderer()
//            calendarRenderer.show(selectedDate: Date(), handler: nil)
//        }
        if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [UIApplication.LaunchOptionsKey : Any] {
            for key in userActivityDictionary.keys {
                if let userActivity = userActivityDictionary[key] as? NSUserActivity, let url = userActivity.webpageURL {
                    DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] (dynamiclink, error) in
                    if let deepLink = dynamiclink?.url, let eventId = deepLink.queryParameters[GlobalConstant.eventIdKey] {
                        self?.defaultsStorage.set(value: eventId, forKey: .inventLinkEventId)
                        NotificationCenter.default.post(name: .handleDeepLinkInvent, object: nil)
                        }
                    }
                    break
                }
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamiclink, error) in
        if let deepLink = dynamiclink?.url, let eventId = deepLink.queryParameters[GlobalConstant.eventIdKey] {
            self?.defaultsStorage.set(value: eventId, forKey: .inventLinkEventId)
            if self?.authorizationService.isLoggedIn == true {
                UIApplication.setRootViewController(UINavigationController(
                    rootViewController: R.storyboard.eventsList.eventsListViewController()!)
                )
            }
        }
      }

      return handled
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        print("Here")
//      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
//        // Handle the deep link. For example, show the deep-linked content or
//        // apply a promotional offer to the user's account.
//        // ...
//        return true
//      }
//      return false
//    }
}
