//
//  AdditionalReactionsInteractor.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

final class AdditionalReactionsInteractor {
    
    internal let defaultsStorage: DefaultsStorageType
    //weak var output: ReactionsSettingsInteractorOutput?
    
    // MARK: - Init
    
    init(defaultsStorage: DefaultsStorageType) {
        self.defaultsStorage = defaultsStorage
    }
}

extension AdditionalReactionsInteractor: AdditionalReactionsInteractorInput { }
