//
//  Colors.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import Rswift
import SwiftUI

extension Rswift.ColorResource {
    
    var color: Color {
        Color(self.name)
    }
}

extension Color {
    
    static var r: R.color.Type {
        R.color.self
    }
}
