//
//  NewEventPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

final class NewEventPresenter {

    // MARK: - Properties

    weak var view: NewEventViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.fetchOfftenGames()
                self?.fetchOfftenTime()
            }
            view.calendarAction = { [weak self] in
                self?.router.showCalendar{ [weak self] date in
                    self?.view.updateDayDate(with: NewEventDayDateViewModel(date: date))
                }
            }
            view.searchGameAction = { [weak self] in
                self?.router.openGameSearch(
                    offtenGames: self?.gamesDataSours.offtenItems,
                    selectionHandler: { selectedGame in
                        self?.gamesDataSours.setupViewModels(items: [selectedGame], selected: true)
                        self?.view.showGames(true)
                    }
                )
            }
        }
    }
    var interactor: NewEventInteractorInput!
    var router: NewEventRouterInput!
    
    // MARK: - Private
    
    private var gamesDataSours: NewEventDataSource<Game, NewEventGameCellViewModel, NewEventGameCell>!
    
    private func fetchOfftenGames() {
        view.showGamesLoading()
        interactor.fetchOfftenGames { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideGamesLoading()
            switch result {
            case .success(let games):
                self.gamesDataSours = NewEventDataSource(
                    offtenItems: games,
                    multipleSelection: false,
                    selectAction: { [weak self] selectedGames in
                        self?.view.updateGames()
                    }
                )
                self.view.setGamesDataSource(self.gamesDataSours)
                self.view.showGames(!games.isEmpty)
            case .failure(let error):
                break
            }
        }
    }
    
    private func fetchOfftenTime() {
        view.showTimeLoading()
        interactor.fetchOfftenTime { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let time):
                self.view.setTime(time ?? Date())
            case .failure(let error):
                break
            }
        }
    }
}

// MARK: - NewEventModuleInput

extension NewEventPresenter: NewEventModuleInput {

}
