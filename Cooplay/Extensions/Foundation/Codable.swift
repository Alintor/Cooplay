//
//  Codable.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        return dictionary(with: JSONEncoder())
    }
    
    func dictionary(with encoder: JSONEncoder) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments)
        ).flatMap { $0 as? [String: Any] }
    }
}
