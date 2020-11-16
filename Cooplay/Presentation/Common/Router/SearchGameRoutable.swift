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
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let searchGameViewController = R.storyboard.searchGame.searchGameViewController()!
        searchGameViewController.output?.configure(offtenGames: offtenGames, selectedGame: selectedGame, selectionHandler: selectionHandler)
        let navigationController = UINavigationController(rootViewController: searchGameViewController)
        transitionHandler.present(navigationController, animated: true, completion: nil)
    }
}
