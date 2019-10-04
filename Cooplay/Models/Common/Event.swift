//
//  Event.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    let game: Game
    let date: Date
    let members: [User]
    let me: User
}
