//
//  EventFirebaseResponse.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
struct EventFirebaseResponse: Codable {
    
    let id: String
    let game: Game
    let date: String
    var members: [String: User]
    
    func getModel(userId: String) -> Event? {
        guard let me = members[userId] else { return nil }
        
        return Event(
            id: id,
            game: game,
            date: date.convertServerDate!,
            members: members.values.filter { $0.id != userId },
            me: me
        )
    }
}
