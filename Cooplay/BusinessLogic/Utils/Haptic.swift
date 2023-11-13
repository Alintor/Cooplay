//
//  Haptic.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import UIKit


enum Haptic {
    
    static func play(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
