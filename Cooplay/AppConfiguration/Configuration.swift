//
//  AppConfiguration.swift
//  Cooplay
//
//  Created by Alexandr on 07/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

enum AppConfiguration {

    private static let mainBundle = Bundle.main.infoDictionary
    static let bundleID = Bundle.main.bundleIdentifier ?? ""
    static let userKey = mainBundle?["DBGamesUserKey"] as? String ?? ""
    static let DBClientId = mainBundle?["DBGamesClientId"] as? String ?? ""
    static let DBClientSecret = mainBundle?["DBGamesClientSecret"] as? String ?? ""
    static let dynamicLinkDomain = mainBundle?["DynamicLinkDomain"] as? String ?? ""
    static let dynamicLinkCustomScheme = mainBundle?["DynamicLinkCustomScheme"] as? String ?? ""
    static let appleAppId = mainBundle?["AppleAppId"] as? String ?? ""
    static let officialSite = mainBundle?["OfficialSite"] as? String ?? ""
}
