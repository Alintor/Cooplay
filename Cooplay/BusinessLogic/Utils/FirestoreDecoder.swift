//
//  FirestoreDecoder.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

struct FirestoreDecoder {
    
    static func decode<T : Decodable>(_ data: [String: Any], to model: T.Type) throws -> T {
        let jsonData =  try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(model, from: jsonData)
    }
}
