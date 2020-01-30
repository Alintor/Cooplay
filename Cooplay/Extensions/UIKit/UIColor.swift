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
    
    var isLight: Bool {
        guard let components = cgColor.components,
            components.count >= 3 else { return false }
        let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
        return !(brightness < 0.5)
    }
    
    var complementaryColor: UIColor {
        return isLight ? darker() : lighter()
    }
    
    func lighter(by percentage: CGFloat = 1.35) -> UIColor {
        return self.adjust(by: percentage)
    }
    
    func darker(by percentage: CGFloat = 0.95) -> UIColor {
        return self.adjust(by: percentage )
    }
    
    func adjust(by percent: CGFloat) -> UIColor {
        
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
          if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
           return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
          }
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + (percent - 1) / 5, 1.0),
                green: min(green + (percent - 1) / 5, 1.0),
                blue: min(blue + (percent - 1) / 5, 1.0),
                alpha: alpha
            )
        }
        return self
    }
}
