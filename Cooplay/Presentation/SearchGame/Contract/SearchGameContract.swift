//
//  SearchGameContract.swift
//  Cooplay
//
//  Created by Alexandr on 15.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import DTModelStorage

// MARK: - View

protocol SearchGameViewInput: KeyboardHandler, ActivityIndicatorRenderer {

    func setupInitialState()
}

protocol SearchGameViewOutput: AnyObject {
    
    func didLoad()
    func didTapClose()
    func setDataSource(_ dataSource: MemoryStorage)
    func didSelectItem(_ item: SearchGameCellViewModel)
    func didSearchGame(_ value: String)
}

// MARK: - Interactor

protocol SearchGameInteractorInput: AnyObject {

    func searchGame(
        _ searchValue: String,
        completion: @escaping (Result<[Game], SearchGameError>) -> Void
    )
    func fetchOfftenGames(completion: @escaping (Result<[Game], SearchGameError>) -> Void)
}

// MARK: - Router

protocol SearchGameRouterInput: CloseableRouter { }

// MARK: - Module Input

protocol SearchGameModuleInput: AnyObject {

    func configure(
        offtenGames: [Game]?,
        selectedGame: Game?,
        selectionHandler: ((_ game: Game) -> Void)?
    )
}
