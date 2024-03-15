//
//  DefaultsStorage.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/07/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import Foundation

protocol DefaultsStorageType {
    
    func set(value: Any, forKey key: DefaultsStorageKey)
    func get(valueForKey key: DefaultsStorageKey) -> Any?
    func remove(valueForKey key: DefaultsStorageKey)
    func clear()
}

enum DefaultsStorageKey: String, CaseIterable {
    
    case showDeclinedEvents
    case inventLinkEventId
    case gameDBToken
    case reactions
    case recentReactions
    
    static let userData: [DefaultsStorageKey] = [.showDeclinedEvents, .inventLinkEventId, .gameDBToken]
}

final class DefaultsStorage {
    
    private let defaults: UserDefaults
    
    // MARK: - Init
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

extension DefaultsStorage: DefaultsStorageType {
    
    func set(value: Any, forKey key: DefaultsStorageKey) {
        defaults.set(value, forKey: key.rawValue)
        defaults.synchronize()
    }
    
    func get(valueForKey key: DefaultsStorageKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
    
    func remove(valueForKey key: DefaultsStorageKey) {
        defaults.removeObject(forKey: key.rawValue)
        defaults.synchronize()
    }
    
    func clear() {
        for key in DefaultsStorageKey.userData {
            self.remove(valueForKey: key)
        }
    }
}
