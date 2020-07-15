//
//  URL.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 13/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

extension URL {
    
    var queryParameters: [String: String] {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
        else {
            return [:]
        }
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}
