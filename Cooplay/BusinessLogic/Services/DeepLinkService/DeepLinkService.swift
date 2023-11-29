//
//  DeepLinkService.swift
//  Cooplay
//
//  Created by Alexandr on 29.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase

final class DeepLinkService {
    
    private let defaultsStorage: DefaultsStorageType
    
    // MARK: - Init
    
    init(defaultsStorage: DefaultsStorageType) {
        self.defaultsStorage = defaultsStorage
    }
    
    // MARK: - Private
    
    private var inviteEventId: String? {
        get {
            defaultsStorage.get(valueForKey: .inventLinkEventId) as? String
        }
        set {
            if let id = newValue {
                defaultsStorage.set(value: id, forKey: .inventLinkEventId)
            } else {
                defaultsStorage.remove(valueForKey: .inventLinkEventId)
            }
        }
    }
    
}

extension DeepLinkService: Middleware {
    
    func perform(store: Store, action: StoreAction) {
        switch action {
        case .handleDeepLink(let url):
            DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] (dynamiclink, error) in
                if let deepLink = dynamiclink?.url, let eventId = deepLink.queryParameters[GlobalConstant.eventIdKey] {
                    if store.state.value.authentication.isAuthenticated {
                        store.dispatch(.addEvent(eventId))
                    } else {
                        self?.inviteEventId = eventId
                    }
                }
            }
            
        case .successAuthentication:
            if let eventId = inviteEventId {
                inviteEventId = nil
                store.dispatch(.addEvent(eventId))
            }
            
        default: break
        }
    }
    
}
