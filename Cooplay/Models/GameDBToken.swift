//
//  GameDBToken.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/10/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct GameDBToken: Codable {
    
    let accessToken: String
    let expiresIn: Int
    let expiresAt: Date
    let tokenType: String
    
    var token: String {
        return "\(tokenType.capitalized) \(accessToken)"
    }
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        let expires = try container.decode(Int.self, forKey: .expiresIn)
        expiresIn = expires
        expiresAt = (try? container.decode(Date.self, forKey: .expiresAt)) ?? Date(timeIntervalSinceNow: Double(expires) as TimeInterval)
    }
    
    
}
