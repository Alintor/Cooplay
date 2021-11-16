//
//  EventInfoViewModel.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import Foundation

struct EventInfoViewModel {
    
    let title: String
    let date: String
    let coverPath: String?
    
    init(with event: Event) {
        title = event.game.name
        date = event.date.displayString
        coverPath = event.game.coverPath
    }
}
