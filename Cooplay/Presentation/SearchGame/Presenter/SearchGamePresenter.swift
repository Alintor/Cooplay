//
//  SearchGamePresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import DTModelStorage

final class SearchGamePresenter {

    // MARK: - Properties

    private weak var view: SearchGameViewInput!
    private let interactor: SearchGameInteractorInput
    private let router: SearchGameRouterInput
    
    // MARK: - Init
    
    init(
        view: SearchGameViewInput,
        interactor: SearchGameInteractorInput,
        router: SearchGameRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
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
        //dataSource.setSectionHeaderModel(sectionHeader, forSection: 0)
        dataSource.headerModelProvider = { index in
            guard index == 0 else { return nil }
            return sectionHeader
        }
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
//        dataSource.setSectionHeaderModel(
//            SearchSectionHeaderViewModel(with: R.string.localizable.searchGameSectionsSearchResults()),
//            forSection: 0
//        )
        dataSource.headerModelProvider = { index in
            guard index == 0 else { return nil }
            return SearchSectionHeaderViewModel(with: R.string.localizable.searchGameSectionsSearchResults())
        }
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

// MARK: - SearchGameViewOutput

extension SearchGamePresenter: SearchGameViewOutput {
    
    func didLoad() {
        view.setupInitialState()
    }
    
    func didTapClose() {
        router.close(animated: true)
    }
    
    func setDataSource(_ dataSource: DTModelStorage.MemoryStorage) {
        self.dataSource = dataSource
        showOfftenGames()
    }
    
    func didSelectItem(_ item: SearchGameCellViewModel) {
        selectionHandler?(item.model)
        router.close(animated: true)
    }
    
    func didSearchGame(_ value: String) {
        if value.isEmpty { showOfftenGames() }
        guard value.count > 2 else { return }
        searchGame(value)
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
