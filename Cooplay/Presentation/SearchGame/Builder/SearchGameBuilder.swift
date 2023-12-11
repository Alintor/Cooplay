//
//  SearchGameBuilder.swift
//  Cooplay
//
//  Created by Alexandr on 12.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Swinject

final class SearchGameBuilder {
    
    func build(
        offtenGames: [Game]?,
        selectedGame: Game?,
        selectionHandler: ((_ game: Game) -> Void)?
    ) -> UIViewController {
        let r = ApplicationAssembly.assembler.resolver
        
        let viewController = R.storyboard.searchGame.searchGameViewController()!
        let interactor = SearchGameInteractor(
            gamesService: r.resolve(GamesServiceType.self),
            userService: r.resolve(UserServiceType.self), 
            eventService: r.resolve(EventServiceType.self)
        )
        let router = SearchGameRouter(rootViewController: viewController)
        let presenter = SearchGamePresenter(
            view: viewController,
            interactor: interactor,
            router: router
        )
        presenter.configure(offtenGames: offtenGames, selectedGame: selectedGame, selectionHandler: selectionHandler)
        viewController.output = presenter
        
        return viewController
    }
}
