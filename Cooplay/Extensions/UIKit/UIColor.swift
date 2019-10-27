//
//  UIColor.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static var avatarColors: [UIColor] {
        return [
            UIColor(red: 0.87, green: 0.27, blue: 0.33, alpha: 1),
            UIColor(red: 0.47, green: 0.4, blue: 0.76, alpha: 1),
            UIColor(red: 0.86, green: 0.53, blue: 0.23, alpha: 1),
            UIColor(red: 0.8, green: 0.31, blue: 0.53, alpha: 1),
            UIColor(red: 0.26, green: 0.53, blue: 0.73, alpha: 1)
        ]
    }
    
    static func avatarBackgroundColor(_ seed: String) -> UIColor {
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        let index = total % avatarColors.count
        return avatarColors[index]
    }
}
