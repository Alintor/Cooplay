//
//  ReactionsSettingsInteractor.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

final class ReactionsSettingsInteractor {
    
    internal let defaultsStorage: DefaultsStorageType
    weak var output: ReactionsSettingsInteractorOutput?
    
    // MARK: - Init
    
    init(defaultsStorage: DefaultsStorageType) {
        self.defaultsStorage = defaultsStorage
    }
}

extension ReactionsSettingsInteractor: ReactionsSettingsInteractorInput { }
