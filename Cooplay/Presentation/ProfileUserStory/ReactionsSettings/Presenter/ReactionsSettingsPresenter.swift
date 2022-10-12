//
//  ReactionsSettingsPresenter.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

final class ReactionsSettingsPresenter {
    
    // MARK: - Properties
    
    private weak var view: ReactionsSettingsViewInput?
    private let interactor: ReactionsSettingsInteractorInput
    private let router: ReactionsSettingsRouterInput
    private var initialReactions = [String]()
    
    // MARK: - Init
    
    init(
        view: ReactionsSettingsViewInput?,
        interactor: ReactionsSettingsInteractorInput,
        router: ReactionsSettingsRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    deinit {
        let myReactions = interactor.myReactions
        for reaction in initialReactions {
            if !myReactions.contains(reaction) {
                interactor.addRecentReaction(reaction)
            }
        }
    }
}

// MARK: - ReactionsSettingsViewOutput

extension ReactionsSettingsPresenter: ReactionsSettingsViewOutput {
    
    func didLoad() {
        initialReactions = interactor.myReactions
        view?.updateReactions(interactor.myReactions)
    }
    
    func didSelectReaction(_ reaction: String, for index: Int) {
        var reactions = interactor.myReactions
        if let oldIndex = reactions.firstIndex(where: { $0 == reaction }) {
            let oldReaction = reactions[index]
            reactions[oldIndex] = oldReaction
        }
        reactions[index] = reaction
        view?.updateReactions(reactions)
        interactor.updateMyReactions(reactions)
    }
    
    func getAllReactions() -> [[String]] {
        interactor.allReactions
    }
    
}

// MARK: - ReactionsSettingsInteractorOutput

extension ReactionsSettingsPresenter: ReactionsSettingsInteractorOutput { }

// MARK: - ReactionsSettingsModuleInput

extension ReactionsSettingsPresenter: ReactionsSettingsModuleInput { }
