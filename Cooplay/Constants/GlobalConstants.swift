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
    }
    
    enum CoordinateSpace {
        
        static let home = "Home"
        static let profile = "Profile"
    }
    
    static var eventActivePeriodHours = 1
    static var eventConfirmPeriodMinutes = 30
    static var eventIdKey = "eventId"
    static var eventDurationHours = 3
    static var eventOverdueMonths = 6
    static let defaultsReactions = ["👍", "👎", "👀", "😘", "😭", "😡"]
}

var localizableUITableName = "Localizable"
