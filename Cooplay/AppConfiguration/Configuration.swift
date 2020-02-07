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
    static let userKey = mainBundle?["DBGamesUserKey"] as? String ?? ""
}
