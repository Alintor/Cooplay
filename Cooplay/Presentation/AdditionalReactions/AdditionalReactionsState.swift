//
//  AdditionalReactionsState.swift
//  Cooplay
//
//  Created by Alexandr on 16.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import Combine

class AdditionalReactionsState: ObservableObject, AllReactionsConfigurable {
    
    internal let defaultsStorage: DefaultsStorageType
    @Published var selectedReactions: [String]
    private let handler: ((Reaction?) -> Void)?
    
    // MARK: - Init
    
    init(defaultsStorage: DefaultsStorageType, selectedReaction: String?, handler: ((Reaction?) -> Void)?) {
        self.defaultsStorage = defaultsStorage
        if let selectedReaction = selectedReaction {
            self.selectedReactions = [selectedReaction]
        } else {
            self.selectedReactions = []
        }
        self.handler = handler
    }
    
    // MARK: - Methods
    
    func getAllReactions() -> [[String]] {
        var allReactions = self.allReactions
        allReactions[0] = self.myReactions
        return allReactions
    }
    
    func didSelectReaction(_ reaction: String?) {
        if let reaction = reaction {
            self.addRecentReaction(reaction)
            handler?(Reaction(style: .emoji, value: reaction))
        } else {
            handler?(nil)
        }
    }

}
