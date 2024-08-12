//
//  SearchGameState.swift
//  Cooplay
//
//  Created by Alexandr on 10.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation

class SearchGameState: ObservableObject {
    
    // MARK: - Properties
    
    private let eventService: EventServiceType
    private let gamesService: GamesServiceType
    @Published var oftenGames: [NewEventGameViewModel]?
    @Published var searchResultGames: [NewEventGameViewModel]?
    @Published var showProgress: Bool = false
    var selectedGame: Game?
    var close: (() -> Void)?
    var selectionHandler: ((_ game: Game) -> Void)?
    
    // MARK: - Init
    
    init(
        eventService: EventServiceType,
        gamesService: GamesServiceType,
        oftenGames: [Game]?,
        selectedGame: Game?,
        selectionHandler: ((_ game: Game) -> Void)?
    ) {
        self.eventService = eventService
        self.gamesService = gamesService
        self.selectionHandler = selectionHandler
        self.selectedGame = selectedGame
        if let oftenGames {
            self.oftenGames = oftenGames.map({ NewEventGameViewModel(model: $0, isSelected: selectedGame?.slug == $0.slug)})
        }
    }
    
    // MARK: - Methods
    
    func tryFetchOftenDataIfNeeded() {
        guard oftenGames == nil else { return }
        
        Task {
            do {
                let data = try await eventService.fetchOftenData()
                await MainActor.run {
                    oftenGames = data.games.map({ NewEventGameViewModel(model: $0, isSelected: selectedGame?.slug == $0.slug)})
                }
            } catch {
                await MainActor.run {
                    oftenGames = []
                }
            }
        }
    }
    
    func searchGame(name: String) {
        guard name.count >= 3 else { return }
        
        showProgress = true
        Task {
            do {
                let games = try await gamesService.searchGame(name)
                await MainActor.run {
                    showProgress = false
                    searchResultGames = games.map({ NewEventGameViewModel(model: $0, isSelected: selectedGame?.slug == $0.slug)})
                }
            } catch {
                await MainActor.run {
                    showProgress = false
                    searchResultGames = []
                }
            }
        }
    }
    
    func didSelectGame(_ game: Game) {
        selectionHandler?(game)
        close?()
    }
    
}
