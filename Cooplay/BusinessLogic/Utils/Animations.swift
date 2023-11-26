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
    case gameCover(_ eventId: String)
    case gameName(_ eventId: String)
    case eventDate(_ eventId: String)
    case member(_ memberId: String, eventId: String)
    case eventCover(_ eventId: String)
    case eventStatus(_ eventId: String)
    
    var name: String {
        switch self {
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
        //.smooth(duration: 0.3)
        //.spring(duration: 0.3)
    }
    
    static var stackTransition: SwiftUI.Animation {
        .interpolatingSpring(stiffness: 250, damping: 30)
    }
    
    static var fastTransition: SwiftUI.Animation {
        //.interpolatingSpring(stiffness: 400, damping: 30)
        .snappy(duration: 0.3)
    }
}
