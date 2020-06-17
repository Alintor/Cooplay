//
//  UserServiceAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject
import Firebase

final class UserServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(UserServiceType.self) { r in
            return UserService(
                storage: HardcodedStorage(),
                firebaseAuth: Auth.auth(),
                firestore: Firestore.firestore()
            )
        }
    }
}
