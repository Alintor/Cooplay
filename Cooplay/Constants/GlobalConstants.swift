//
//  Constants.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

enum GlobalConstant {
    
    enum Format {
        
        enum Date: String {
            case serverDate = "yyyy-MM-dd HH:mm:ss ZZZ",
            time = "HH:mm"
        }
        
        static let passwordMinLength = 8
        static let numericSymbols = "0123456789"
    }
    
    enum CoordinateSpace {
        
        static let eventsList = "eventsList"
        static let eventDetails = "eventDetails"
        static let profile = "profile"
        static let home = "home"
    }
    
    static var eventActivePeriodHours = 1
    static var eventConfirmPeriodMinutes = 30
    static var eventIdKey = "eventId"
    static var eventDurationHours = 3
    static var eventOverdueMonths = 6
    static let defaultsReactions = ["👍", "👎", "👀", "😘", "😭", "😡"]
    static let appleAppId = "1523433260"
    static let webLink = "https://ruwus.app"
}

var localizableUITableName = "Localizable"
