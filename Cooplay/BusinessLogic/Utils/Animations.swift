//
//  MatchedAnimations.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

enum MatchedAnimations {
    
    case logo
    case profileAvatar
    case closeButton
    case newEventButton
    case gameCover(_ eventId: String)
    case gameName(_ eventId: String)
    case eventDate(_ eventId: String)
    case member(_ memberId: String, eventId: String)
    case eventCover(_ eventId: String)
    case eventStatus(_ eventId: String)
    case loginButton
    case registerButton
    case timeView
    
    var name: String {
        switch self {
        case .logo:
            return "logo"
        case .profileAvatar:
            return "profileAvatar"
        case .closeButton:
            return "closeButton"
        case .newEventButton:
            return "newEventButton"
        case .gameCover(let eventId):
            return "gameCover_\(eventId)"
        case .gameName(let eventId):
            return "gameName_\(eventId)"
        case .eventDate(let eventId):
            return "eventDate_\(eventId)"
        case .member(let memberId, let eventId):
            return "member_\(memberId)_\(eventId)"
        case .eventCover(let eventId):
            return "eventCover_\(eventId)"
        case .eventStatus(let eventId):
            return "eventStatus_\(eventId)"
        case .loginButton:
            return "loginButton"
        case .registerButton:
            return "registerButton"
        case .timeView:
            return "timeView"
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
        //.interpolatingSpring(stiffness: 280, damping: 25)
        //.interpolatingSpring(stiffness: 300, damping: 28)
        //.interpolatingSpring(duration: 0.3)
        .snappy(duration: 0.3)
        //.easeIn(duration: 0.3)
        //.smooth(duration: 0.2)
        //.spring(duration: 0.3)
    }
    
    static var stackTransition: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 250, damping: 30)
    }
    
    static var fastTransition: SwiftUI.Animation {
        //.interpolatingSpring(stiffness: 400, damping: 30)
        .snappy(duration: 0.3)
    }
    
    static var bounceTransition: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 350, damping: 15)
    }
    
    static var springTransition: SwiftUI.Animation {
        .spring(duration: 0.3)
    }
}
