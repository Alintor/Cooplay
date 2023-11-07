//
//  ReactionsSettingsState.swift
//  Cooplay
//
//  Created by Alexandr on 07.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

class ReactionsSettingsState: ObservableObject, AllReactionsConfigurable {
    
    // MARK: - Properties
    
    @Published var reactions: [String] = []
    internal let  defaultsStorage: DefaultsStorageType
    private var initialReactions = [String]()
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - Init
    
    init(defaultsStorage: DefaultsStorageType) {
        self.defaultsStorage = defaultsStorage
        initialReactions = myReactions
        reactions = myReactions
    }
    
    deinit {
        let myReactions = myReactions
        for reaction in initialReactions {
            if !myReactions.contains(reaction) {
                addRecentReaction(reaction)
            }
        }
    }
    
    // MARK: - Methods
    
    func didSelectReaction(_ reaction: String, for index: Int) {
        var reactions = myReactions
        if let oldIndex = reactions.firstIndex(where: { $0 == reaction }) {
            let oldReaction = reactions[index]
            reactions[oldIndex] = oldReaction
        }
        reactions[index] = reaction
        generator.prepare()
        if !self.reactions.isEmpty && self.reactions != reactions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.generator.impactOccurred()
            }
        }
        self.reactions = reactions
        updateMyReactions(reactions)
    }
}
