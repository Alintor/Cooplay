//
//  StatusDetailsViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 26.07.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation

struct StatusDetailsViewModel {
    
    let title: String
    let subtitle: String
    
    init(with date: Date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.dateFormat = GlobalConstant.Format.Date.time.rawValue
        title = timeFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        subtitle = dateFormatter.string(from: date).lowercased()
    }
}
