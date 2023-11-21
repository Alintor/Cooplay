//
//  Store.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation

final class Store {
    
    let state: CurrentValueSubject<GlobalState, Never>
    
    private let middleware: [Middleware]
    private let reducers: [Reducer]
    private let queue = DispatchQueue(label: "store", qos: .default)
    
    init(
        state: GlobalState,
        middleware: [Middleware],
        reducers: [Reducer]
    ) {
        self.middleware = middleware
        self.reducers = reducers
        self.state = CurrentValueSubject<GlobalState, Never>(state)
    }
    
    func dispatch(_ action: StoreAction) {
        queue.async {
            var state = self.state.value
            self.reducers.forEach { state = $0(state, action) }
            self.middleware.forEach { $0.perform(store: self, action: action) }
            DispatchQueue.main.async {
                self.state.value = state
            }
        }
    }
}

