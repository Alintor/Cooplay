//
//  FeedbackRequest.swift
//  Cooplay
//
//  Created by Alexandr on 17.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation

struct FeedbackRequest: Codable {
    
    let message: String
    let userId: String
    let date: String
    let platform: String
    let osVersion: String
    let appVersion: String
}
