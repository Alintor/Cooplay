//
//  NewEventRequest.swift
//  Cooplay
//
//  Created by Alexandr on 05/03/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftDate

struct NewEventRequest: Codable {
    
    var id: String
    var game: Game?
    var date: String?
    var members: [User]?
    
    init(id: String) {
        self.id = id
    }
    
    func getDate() -> Date? {
        date?.convertServerDate
    }
    
    mutating func setTime(_ time: Date) {
        let currentDate = getDate() ?? Date()
        let components = Calendar.current.dateComponents(in: .current, from: time)
        guard
            let hour = components.hour,
            let minute = components.minute,
            var newDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: currentDate)
        else { return }
        let minimumDate = Date() + 5.minutes
        if newDate < minimumDate {
            newDate = minimumDate.rounded(minutes: 5, rounding: .ceil)
        }
        date = newDate.toString(.custom(GlobalConstant.Format.Date.serverDate.rawValue))
    }
    
    mutating func setDate(_ date: Date) {
        let currentDate = getDate() ?? Date()
        let components = Calendar.current.dateComponents(in: .current, from: currentDate)
        guard
            let hour = components.hour,
            let minute = components.minute,
            var newDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: date)
        else { return }
        let minimumDate = Date() + 5.minutes
        if newDate < minimumDate {
            newDate = minimumDate.rounded(minutes: 5, rounding: .ceil)
        }
        self.date = newDate.toString(.custom(GlobalConstant.Format.Date.serverDate.rawValue))
    }
}
