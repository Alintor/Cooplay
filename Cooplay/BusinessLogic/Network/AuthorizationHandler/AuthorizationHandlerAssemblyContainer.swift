//
//  AuthorizationHandlerAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject

final class AuthorizationHandlerAssemblyContainer: Assembly {
    func assemble(container: Container) {
        container.register(AuthorizationHandlerType.self) { (_) in
            return AuthorizationHandler()
        }
    }
}
