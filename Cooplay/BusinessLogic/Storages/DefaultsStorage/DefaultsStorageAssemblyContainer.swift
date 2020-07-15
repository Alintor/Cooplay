//
//  DefaultsStorageAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Swinject

final class DefaultsStorageAssemblyContainer: Assembly {
    
    func assemble(container: Container) {
        container.register(DefaultsStorageType.self) { _ in
            return DefaultsStorage(defaults: .standard)
        }
    }
}
