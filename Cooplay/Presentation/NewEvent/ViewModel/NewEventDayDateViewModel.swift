//
//  NewEventDayDateViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 22/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import SwiftDate

struct NewEventDayDateViewModel {
    
    let day: String
    let month: String
    
    init(date: Date) {
        day = date.string(custom: "d")
        month = "\(date.string(custom: "MMM").prefix(3))"
    }
}
