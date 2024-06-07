//
//  GamesServiceAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr on 28/01/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation
import Swinject

final class GamesServiceAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(GamesServiceType.self) { r in
            return GamesService(
                provider: r.resolve(APIProviderType.self),
                defaultsStorage: r.resolve(DefaultsStorageType.self)
            )
        }
    }
}
