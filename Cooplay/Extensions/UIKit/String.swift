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
}
