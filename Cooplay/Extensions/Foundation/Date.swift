//
//  Date.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation

enum DateRoundingType {
    
    case round
    case ceil
    case floor
}

extension Date {
    
    var displayString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        
        return "\(dateFormatter.string(from: self)), \(timeFormatter.string(from: self))"
    }
    
    var timeDisplayString: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        
        return "\(timeFormatter.string(from: self))"
    }
    
    var UTCString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = GlobalConstant.Format.Date.serverDate.rawValue
        return dateFormatter.string(from: self)
    }
    
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
    
}
