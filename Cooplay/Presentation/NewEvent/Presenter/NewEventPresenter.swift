//
//  NewEventPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation
import SwiftDate

final class NewEventPresenter {
    
    private enum Constant {
        
        static let defaultTime = Calendar.current.date(bySettingHour: 21, minute: 00, second: 0, of: Date())!
    }

    // MARK: - Properties

    private weak var view: NewEventViewInput!
    private let interactor: NewEventInteractorInput
    private let router: NewEventRouterInput
    private var closeHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(
        view: NewEventViewInput,
        interactor: NewEventInteractorInput,
        router: NewEventRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private
    
    private var gamesDataSours: NewEventDataSource<Game, NewEventGameCellViewModel, NewEventGameCell>!
    private var membersDataSours: NewEventDataSource<User, NewEventMemberCellViewModel, NewEventMemberCell>!
    private var request = NewEventRequest(id: UUID().uuidString) {
        didSet {
            view.setCreateButtonEnabled(interactor.isReady(request))
            if let time = request.getDate() {
                view.setTime(time)
            }
        }
    }
    
    private func fetchOfftenData() {
        view.showLoading()
        interactor.fetchofftenData { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideLoading()
            switch result {
            case .success(let response):
                self.gamesDataSours = NewEventDataSource(
                    offtenItems: response.games,
                    multipleSelection: false,
                    showCount: 4,
                    selectAction: { [weak self] selectedGames in
                        self?.request.game = selectedGames.first
                        self?.view.updateGames()
                    }
                )
                self.view.setGamesDataSource(self.gamesDataSours)
                self.view.showGames(!response.games.isEmpty)
                self.membersDataSours = NewEventDataSource(
                    offtenItems: response.members,
                    multipleSelection: true,
                    showCount: 5,
                    selectAction: nil
                )
                //self.view.updateMembers()
                self.view.setMembersDataSource(self.membersDataSours)
                self.view.showMembers(!response.members.isEmpty)
                let time = response.time ?? Constant.defaultTime
                self.request.setTime(time)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func createNewEvent() {
        interactor.createNewEvent(request)
        closeHandler?()
        self.router.close(animated: true)
    }
}


// MARK: - NewEventViewOutput

extension NewEventPresenter: NewEventViewOutput {
    
    func didLoad() {
        view.setupInitialState()
        fetchOfftenData()
    }
    
    func close() {
        closeHandler?()
    }
    
    func didTapCalendar() {
        router.showCalendar(selectedDate: request.getDate()) { [weak self] date in
            self?.request.setDate(date)
            self?.view.updateDayDate(with: NewEventDayDateViewModel(date: date))
        }
    }
    
    func didTapTime() {
        guard let time = request.getDate() else { return }
        
        router.showTimePicker(startTime: time, enableMinimumTime: Date().day == time.day) { [weak self] (time) in
            self?.request.setTime(time)
        }
    }
    
    func didTapToday() {
        request.setDate(Date())
    }
    
    func didTapTomorrow() {
        let tomorrow = Date() + 1.days
        request.setDate(tomorrow)
    }
    
    func didTapSearchGame() {
        router.openGameSearch(
            offtenGames: gamesDataSours.offtenItems,
            selectedGame: gamesDataSours.selectedItems.first,
            selectionHandler: { [weak self] selectedGame in
                self?.request.game = selectedGame
                self?.gamesDataSours.setupViewModels(items: [selectedGame], selected: true)
                self?.view.showGames(true)
            }
        )
    }
    
    func didTapSearchMember() {
        router.openMembersSearch(
            eventId: request.id,
            offtenMembers: membersDataSours.offtenItems,
            selectedMembers: membersDataSours.selectedItems,
            selectionHandler: { [weak self] selectedMembers in
                self?.membersDataSours.setupViewModels(items: selectedMembers, selected: true)
                self?.view.updateMembers()
                self?.view.showMembers(true)
            }
        )
    }
    
    func didTapMainActionButton() {
        request.members = membersDataSours.selectedItems
        createNewEvent()
    }
    
}

// MARK: - NewEventModuleInput

extension NewEventPresenter: NewEventModuleInput {
    
    func configure(closeHandler: (() -> Void)?) {
        self.closeHandler = closeHandler
    }
}
