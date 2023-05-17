//
//  String+Localizable.swift
//  Cooplay
//
//  Created by Alexandr on 17.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation

typealias Localizable = R.string.localizable

extension Localizable {
    
    static func localizedString(_ source: String) -> String {
        return NSLocalizedString(
            source,
            tableName: Localizable.tableName(),
            comment: ""
        )
    }
    
}
