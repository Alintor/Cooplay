//
//  UIColor.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func avatarBackgroundColor(_ seed: String) -> UIColor {
        let backgroundColors: [UIColor] = [.red, .green, .blue, .cyan, .purple]
        var total: Int = 0
        for u in seed.unicodeScalars {
            total += Int(UInt32(u))
        }
        let index = total % backgroundColors.count
        return backgroundColors[index]
    }
}
