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
        return (date - GlobalConstant.eventActivePeriodHours.hour) <= Date()
    }
    
    var needConfirm: Bool {
        guard (date - GlobalConstant.eventConfirmPeriodMinutes.minutes) <= Date() else { return false }
        switch self.me.status {
        case .accepted, .maybe, .suggestDate, .unknown:
            return true
        default:
            return false
        }
    }
    
    var isAgreed: Bool {
        if case .unknown = me.status {
            return false
        } else {
            return true
        }
    }
    
}

extension Event: Equatable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Event {
     
    func isEqual(_ event: Event) -> Bool {
        guard self.id == event.id
                && self.date == event.date
                && self.game.isEqual(event.game)
                && self.me.isEqual(event.me)
                && self.members.count == event.members.count
        else { return false }
        for member in self.members {
            let contains = event.members.contains { user in
                user.isEqual(member)
            }
            if !contains {
                return false
            }
        }
        return true
    }
}
