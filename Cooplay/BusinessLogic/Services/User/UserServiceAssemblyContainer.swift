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
import FirebaseCore

final class UserServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(UserServiceType.self) { r in
            return UserService(
                storage: Storage.storage(),
                firebaseAuth: Auth.auth(),
                firestore: Firestore.firestore()
            )
        }
    }
}
