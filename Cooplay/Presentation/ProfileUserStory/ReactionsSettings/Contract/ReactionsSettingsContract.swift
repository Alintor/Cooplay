//
//  ReactionsSettingsContract.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation

// MARK: - View

protocol ReactionsSettingsViewInput: AnyObject {
    
    func updateReactions(_ reactions: [String])
}

protocol ReactionsSettingsViewOutput: AnyObject {
    
    func didLoad()
    func didSelectReaction(_ reaction: String, for index: Int)
    func getAllReactions() -> [[String]]
}

// MARK: - Interactor

protocol ReactionsSettingsInteractorInput: AnyObject, AllReactionsConfigurable { }

protocol ReactionsSettingsInteractorOutput: AnyObject { }

// MARK: - Router

protocol ReactionsSettingsRouterInput: AnyObject { }

// MARK: - ModuleInput

protocol ReactionsSettingsModuleInput { }
