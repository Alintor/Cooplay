//
//  NewEventInfoResponse.swift
//  Cooplay
//
//  Created by Alexandr on 05/03/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct NewEventOfftenDataResponse: Codable {
    
    let members: [User]
    let games: [Game]
    let time: String?
}
