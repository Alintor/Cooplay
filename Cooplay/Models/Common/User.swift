//
//  User.swift
//  Cooplay
//
//  Created by Alexandr on 03/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

struct User: Codable {
    
    enum Status: String, Codable {
        
        case ontime,
        maybe,
        late,
        declined,
        unknown
        
        var acceptStatuses: [Status] {
            return [.ontime, .maybe, .declined]
        }
        
        var confirmStatuses: [Status] {
            return [.ontime, .late, .declined]
        }
    }
    
    let id: String
    let name: String
    let avatarPath: String?
    let status: Status?
    let lateness: Int?
}
