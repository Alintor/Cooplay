//
//  Store.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation

class Store {
    
    let state: CurrentValueSubject<GlobalState, Never>
    
    private let effects: [StateEffect]
    private let reducers: [Reducer]
    private let queue = DispatchQueue(label: "store", qos: .default)
    
    init(
        state: GlobalState,
        effects: [StateEffect],
        reducers: [Reducer]
    ) {
        self.effects = effects
        self.reducers = reducers
        self.state = CurrentValueSubject<GlobalState, Never>(state)
    }
    
    func send(_ action: StateAction) {
        queue.async {
            var state = self.state.value
            self.reducers.forEach { state = $0(state, action) }
            self.effects.forEach { $0.perform(store: self, action: action) }
            DispatchQueue.main.async {
                self.state.value = state
            }
        }
    }
}

