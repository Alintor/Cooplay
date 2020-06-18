//
//  EventServiceAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr on 04/10/2019.
//  Copyright © 2019 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase

import Swinject

final class EventServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(EventServiceType.self) { r in
            return EventService(
                storage: HardcodedStorage(),
                firebaseAuth: Auth.auth(),
                firestore: Firestore.firestore()
            )
        }
    }
}
