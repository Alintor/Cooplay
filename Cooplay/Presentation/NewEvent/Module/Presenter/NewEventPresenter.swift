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

    weak var view: NewEventViewInput! {
        didSet {
            // Configure view out
            view.viewIsReady = { [weak self] in
                self?.view.setupInitialState()
                self?.fetchOfftenData()
            }
            view.dateTodaySelected = { [weak self] in
                self?.request.setDate(Date())
            }
            view.dateTomorrowSelected = { [weak self] in
                let tomorrow = Date() + 1.days
                self?.request.setDate(tomorrow)
            }
            view.calendarAction = { [weak self] in
                self?.router.showCalendar(selectedDate: self?.request.getDate()){ [weak self] date in
                    self?.request.setDate(date)
                    self?.view.updateDayDate(with: NewEventDayDateViewModel(date: date))
                }
            }
            view.searchGameAction = { [weak self] in
                self?.router.openGameSearch(
                    offtenGames: self?.gamesDataSours.offtenItems,
                    selectionHandler: { selectedGame in
                        self?.request.game = selectedGame
                        self?.gamesDataSours.setupViewModels(items: [selectedGame], selected: true)
                        self?.view.showGames(true)
                    }
                )
            }
            view.searchMembersAction = { [weak self] in
                guard let `self` = self else { return }
                self.router.openMembersSearch(
                    offtenMembers: self.membersDataSours.offtenItems,
                    selectedMembers: self.membersDataSours.selectedItems,
                    selectionHandler: { [weak self] selectedMembers in
                        self?.membersDataSours.setupViewModels(items: selectedMembers, selected: true)
                        self?.view.updateMembers()
                        self?.view.showMembers(true)
                    }
                )
                
            }
            view.timePickerAction = { [weak self] in
                guard
                    let `self` = self,
                    let time = self.request.getDate()
                else { return }
                self.router.showTimePicker(startTime: time, enableMinimumTime: Date().day == time.day) { [weak self] (time) in
                    self?.request.setTime(time)
                }
            }
            view.mainAction = { [weak self] in
                self?.request.members = self?.membersDataSours.selectedItems
                self?.createNewEvent()
            }
        }
    }
    var interactor: NewEventInteractorInput!
    var router: NewEventRouterInput!
    
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
                    selectAction: nil
                )
                self.view.updateMembers()
                self.view.setMembersDataSource(self.membersDataSours)
                self.view.showMembers(!response.members.isEmpty)
                let time = response.time?.convertServerDate ?? Constant.defaultTime
                self.request.setTime(time)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
    
    private func createNewEvent() {
        view.showProgress(indicatorType: .arrows)
        interactor.createNewEvent(request) { [weak self] result in
            guard let `self` = self else { return }
            self.view.hideProgress()
            switch result {
            case .success:
                self.router.close(animated: true)
            case .failure(let error):
                // TODO:
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - NewEventModuleInput

extension NewEventPresenter: NewEventModuleInput {

}
