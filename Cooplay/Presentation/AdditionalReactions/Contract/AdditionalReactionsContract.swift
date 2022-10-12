//
//  AdditionalReactionsContract.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol AdditionalReactionsViewInput: AnyObject { }

protocol AdditionalReactionsViewOutput: AnyObject {
    
    func didSelectReaction(_ reaction: String)
    func getAllReactions() -> [[String]]
    func didTapCloseButton()
}

// MARK: - Interactor

protocol AdditionalReactionsInteractorInput: AnyObject, AllReactionsConfigurable { }

protocol AdditionalReactionsInteractorOutput: AnyObject { }

// MARK: - Router

protocol AdditionalReactionsRouterInput: AnyObject {
    
    func close(withImpact: Bool)
}

// MARK: - ModuleInput

protocol AdditionalReactionsModuleInput { }
