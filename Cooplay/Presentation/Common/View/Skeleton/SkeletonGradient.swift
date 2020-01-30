//
//  SkeletonGradient.swift
//  Cooplay
//
//  Created by Alexandr on 29/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//


import UIKit

struct SkeletonGradient {
    
    private let gradientColors: [UIColor]
    
     var colors: [CGColor] {
        return gradientColors.map { $0.cgColor }
    }
    
    init(baseColor: UIColor, secondaryColor: UIColor? = nil) {
        if let secondary = secondaryColor {
            self.gradientColors = [baseColor, secondary, baseColor]
        } else {
            self.gradientColors = [baseColor, baseColor.complementaryColor, baseColor]
        }
    }
}
