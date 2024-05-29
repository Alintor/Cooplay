//
//  AuthorizationServiceAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 17/06/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject
import Firebase

final class AuthorizationServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthorizationServiceType.self) { r in
            let firebaseAuth = Auth.auth()
            firebaseAuth.useAppLanguage()
            return AuthorizationService(firebaseAuth: firebaseAuth, firestore: Firestore.firestore(), defaultsStorages: r.resolve(DefaultsStorageType.self))
        }
    }
}
