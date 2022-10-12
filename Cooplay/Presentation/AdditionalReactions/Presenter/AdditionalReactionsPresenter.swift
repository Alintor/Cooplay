//
//  AdditionalReactionsPresenter.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import UIKit

final class AdditionalReactionsPresenter {
    
    // MARK: - Properties
    
    private let interactor: AdditionalReactionsInteractorInput
    private let router: AdditionalReactionsRouterInput
    private var handler: ((_ reaction: Reaction?) -> Void)?
    
    // MARK: - Init
    
    init(
        interactor: AdditionalReactionsInteractorInput,
        router: AdditionalReactionsRouterInput,
        handler: ((_ reaction: Reaction?) -> Void)?
    ) {
        self.interactor = interactor
        self.router = router
        self.handler = handler
    }

}

// MARK: - ReactionsSettingsViewOutput

extension AdditionalReactionsPresenter: AdditionalReactionsViewOutput {
    
    func didSelectReaction(_ reaction: String) {
        interactor.addRecentReaction(reaction)
        handler?(Reaction(style: .emoji, value: reaction))
        router.close(withImpact: true)
    }
    
    func getAllReactions() -> [[String]] {
        var allReactions = interactor.allReactions
        allReactions[0] = interactor.myReactions
        return allReactions
    }
    
    func didTapCloseButton() {
        router.close(withImpact: false)
    }
    
}

// MARK: - ReactionsSettingsInteractorOutput

extension AdditionalReactionsPresenter: AdditionalReactionsInteractorOutput { }

// MARK: - ReactionsSettingsModuleInput

extension AdditionalReactionsPresenter: AdditionalReactionsModuleInput { }
