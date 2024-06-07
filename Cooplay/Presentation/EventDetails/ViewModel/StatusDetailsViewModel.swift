//
//  StatusDetailsViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 26.07.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

struct StatusDetailsViewModel {
    
    let title: String
    let subtitle: String
    let icon: Image
    
    var fullStatus: String {
        return R.string.localizable.statusFullDetails(subtitle.capitalized, title)
    }
    
    init(with date: Date, eventDate: Date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        title = timeFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        subtitle = dateFormatter.string(from: date).lowercased()
        
        if date > eventDate {
            icon = Image(systemName: "arrow.right")
        } else {
            icon = Image(systemName: "arrow.backward")
        }
    }
}
