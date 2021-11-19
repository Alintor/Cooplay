//
//  Reaction.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

struct Reaction: Codable {
    
    enum Style: String, Codable {
        
        case emoji
        case unknown
        
        init(from decoder: Decoder) throws {
            self = try Style(
                rawValue: decoder.singleValueContainer().decode(String.self)
            ) ?? .unknown
        }
    }
    
    var style: Style
    var value: String
    
}
