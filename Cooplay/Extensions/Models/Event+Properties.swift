//
//  Event+sd.swift
//  Cooplay
//
//  Created by Alexandr on 11.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftDate

extension Event {
    
    var isActive: Bool {
        return (date - GlobalConstant.eventActivePeriodHours.hours) <= Date()
    }
    
    var needConfirm: Bool {
        guard (date - GlobalConstant.eventConfirmPeriodMinutes.minutes) <= Date() else { return false }
        switch self.me.status {
        case .accepted, .maybe, .suggestDate, .unknown, .invited:
            return true
        default:
            return false
        }
    }
    
    var isAgreed: Bool {
        if case .invited = me.status {
            return false
        } else {
            return true
        }
    }
}
