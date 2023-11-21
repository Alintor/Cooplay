//
//  StateEffect.swift
//  Cooplay
//
//  Created by Alexandr on 04.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

protocol Middleware {
    
    func perform(store: Store, action: StoreAction)
}
