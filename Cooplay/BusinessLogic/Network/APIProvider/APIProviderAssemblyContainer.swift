//
//  APIProviderAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr on 06/02/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject

final class APIProviderAssemblyContainer: Assembly {
    func assemble(container: Container) {
        container.register(APIProviderType.self) { (r) in
            return APIProvider(
                apiKey: "",
                authorizationHandler: r.resolve(AuthorizationHandlerType.self),
                defaultHeaders: [
                    "user-key": AppConfiguration.userKey
                ]
            )
        }
    }
}
