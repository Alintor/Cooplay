//
//  SearchGamePresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import DTModelStorage

final class SearchGamePresenter {

    // MARK: - Properties

    weak var view: SearchGameViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
            }
            view.closeAction = { [weak self] in
                self?.router.close(animated: true)
            }
            view.dataSourceIsReady = { [weak self] dataSource in
                guard let `self` = self else { return }
                self.dataSource = dataSource
                self.showOfftenGames()
            }
            view.itemSelected = { [weak self] item in
                self?.selectionHandler?(item.model)
                self?.router.close(animated: true)
                
            }
            view.searchGame = { [weak self] searchValue in
                if searchValue.isEmpty { self?.showOfftenGames() }
                guard searchValue.count > 2 else { return }
                self?.searchGame(searchValue)
            }
        }
    }
    var interactor: SearchGameInteractorInput!
    var router: SearchGameRouterInput!
    
    // MARK: - Private
    
    private var dataSource: MemoryStorage!
    private var offtenGames: [Game]!
    private var selectedGame: Game?
    private var selectionHandler: ((_ game: Game) -> Void)?
    
    private func searchGame(_ searchValue: String) {
        view.showProgress(indicatorType: .arrows, fullScreen: false)
        interactor.searchGame(searchValue) { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success(let games):
                self.showSearchResults(games)
            case .failure(let error):
                // TODO:
                break
            }
        }
    }
    
    private func showOfftenGames() {
        guard offtenGames != nil else {
            fetchOfftenGames()
            return
        }
        let sectionHeader = offtenGames.isEmpty ? nil : SearchSectionHeaderViewModel(with: R.string.localizable.searchGameSectionsOfften())
        dataSource.setSectionHeaderModel(sectionHeader, forSection: 0)
        dataSource.setItems(
            offtenGames.map({ SearchGameCellViewModel(with: $0, isSelected: self.selectedGame?.slug == $0.slug )}),
            forSection: 0
        )
    }
    
    private func fetchOfftenGames() {
        view.showProgress(indicatorType: .arrows, fullScreen: false)
        interactor.fetchOfftenGames { [weak self] (result) in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success(let games):
                self.offtenGames = games
            case .failure(let error):
                self.offtenGames = []
                // TODO:
            }
            self.showOfftenGames()
        }
    }
    
    private func showSearchResults(_ games: [Game]) {
        dataSource.setSectionHeaderModel(
            SearchSectionHeaderViewModel(with: R.string.localizable.searchGameSectionsSearchResults()),
            forSection: 0
        )
        if games.isEmpty {
            dataSource.setItems(
                [SearchEmptyResultCellViewModel(with: R.string.localizable.searchGameEmptyResultsTitle())],
                forSection: 0
            )
        } else {
            dataSource.setItems(
                games.map({ SearchGameCellViewModel(with: $0, isSelected: self.selectedGame?.slug == $0.slug )}),
                forSection: 0
            )
        }
    }
    
    
}

// MARK: - SearchGameModuleInput

extension SearchGamePresenter: SearchGameModuleInput {

    func configure(offtenGames: [Game]?, selectedGame: Game?, selectionHandler: ((_ game: Game) -> Void)?) {
        self.offtenGames =  offtenGames
        self.selectionHandler = selectionHandler
        self.selectedGame = selectedGame
    }
}
