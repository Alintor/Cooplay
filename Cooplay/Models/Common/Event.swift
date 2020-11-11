//
//  Event.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftDate

struct Event: Codable {
    
    let id: String
    var game: Game
    var date: Date
    var members: [User]
    var me: User
    
    var isActive: Bool {
        return (date - GlobalConstant.eventActivePeriod.hour) <= Date()
    }
}

extension Event: Equatable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
