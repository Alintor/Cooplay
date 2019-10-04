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
            UIColor(red: 0.47, green: 0.44, blue: 1, alpha: 1),
            UIColor(red: 0.3, green: 0.57, blue: 1, alpha: 1),
            UIColor(red: 0.14, green: 0.77, blue: 0.94, alpha: 1),
            UIColor(red: 0.22, green: 0.86, blue: 0.78, alpha: 1),
            UIColor(red: 0.96, green: 0.29, blue: 0.4, alpha: 1),
            UIColor(red: 0.96, green: 0.61, blue: 0.08, alpha: 1),
            UIColor(red: 0.96, green: 0.51, blue: 0.17, alpha: 1),
            UIColor(red: 0.96, green: 0.41, blue: 0.21, alpha: 1),
            UIColor(red: 0.16, green: 0.78, blue: 0.5, alpha: 1),
            UIColor(red: 0.32, green: 0.76, blue: 0.34, alpha: 1),
            UIColor(red: 0.64, green: 0.76, blue: 0.21, alpha: 1),
            UIColor(red: 0.97, green: 0.75, blue: 0.1, alpha: 1),
            UIColor(red: 0.95, green: 0.29, blue: 0.61, alpha: 1),
            UIColor(red: 0.92, green: 0.25, blue: 0.88, alpha: 1),
            UIColor(red: 0.77, green: 0.26, blue: 0.97, alpha: 1),
            UIColor(red: 0.96, green: 0.24, blue: 0.21, alpha: 1),
            UIColor(red: 0.61, green: 0.25, blue: 1, alpha: 1)
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
