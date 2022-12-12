//
//  EventDetailsNotificationViewModel.swift
//  EventStatusNotification
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

class EventDetailsNotificationViewModel: ObservableObject {
    
    @Published var title: String
    @Published var date: String
    @Published var coverPath: String?
    
    init() {
        title = ""
        date = ""
        coverPath = nil
    }
    
    func update(with event: Event) {
        title = event.game.name
        date = event.date.displayString
        coverPath = event.game.coverPath
    }
}
