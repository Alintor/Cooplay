//
//  SearchGameRoutable.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/11/2020.
//  Copyright © 2020 Ovchinnikov. All rights reserved.
//

import UIKit

protocol SearchGameRoutable: Router {
    
    func openGameSearch(offtenGames: [Game]?, selectedGame: Game?, selectionHandler: ((_ game: Game) -> Void)?)
}

extension SearchGameRoutable {
    
    func openGameSearch(offtenGames: [Game]?, selectedGame: Game?, selectionHandler: ((_ game: Game) -> Void)?) {
        let navigationController = UINavigationController(rootViewController: SearchGameBuilder().build(
            offtenGames: offtenGames,
            selectedGame: selectedGame,
            selectionHandler: selectionHandler
        ))
        rootViewController?.presentModally(navigationController)
    }
}
