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
    case closeButton
    case newEventButton
    
    var name: String {
        switch self {
        case .profileAvatar:
            return "profileAvatar"
        case .closeButton:
            return "closeButton"
        case .newEventButton:
            return "newEventButton"
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
        .interpolatingSpring(stiffness: 280, damping: 25)
        //.interpolatingSpring(stiffness: 300, damping: 28)
        //.easeInOut
    }
}
