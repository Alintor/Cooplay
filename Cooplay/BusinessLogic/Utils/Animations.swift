//
//  MatchedAnimations.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

enum MatchedAnimations {
    
    case profileAvatar
    case profileName
    case closeButton
    
    var name: String {
        switch self {
        case .profileAvatar:
            return "profileAvatar"
        case .profileName:
            return "profileName"
        case .closeButton:
            return "closeButton"
        }
    }
}

class NamespaceWrapper: ObservableObject {
    var id: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.id = namespace
    }
}

extension SwiftUI.Animation {
    
    static var customTransition: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 300, damping: 28)
        //.easeInOut
    }
}
