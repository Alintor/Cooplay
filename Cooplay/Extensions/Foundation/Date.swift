//
//  Date.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation

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
}
