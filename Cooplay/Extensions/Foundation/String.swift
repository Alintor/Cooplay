//
//  String.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import SwiftDate

extension String {
    
    var convertServerDate: Date? {
        return date(format: .custom(GlobalConstant.Format.Date.serverDate.rawValue))?.absoluteDate
    }
    
    var isEmail: Bool {
        // here, `try!` will always succeed because the pattern is valid
        guard let regex = try? NSRegularExpression(
            pattern: "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$",
            options: .caseInsensitive) else { return false }
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
