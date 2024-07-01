//
//  NewEventState.swift
//  Cooplay
//
//  Created by Alexandr on 26.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import Foundation
import SwiftDate

class NewEventState: ObservableObject {
    
    enum DayDate: Equatable {

        case today
        case tomorrow
        case custom(model: NewEventDayDateViewModel)
    }

    // MARK: - Properties
    
    private let store: Store
    private let eventService: EventServiceType
    @Published var games: [NewEventGameCellViewModel]?
    @Published var members: [NewEventMemberCellViewModel]?
    var dayDate: DayDate {
        guard let date = request.getDate() else { return .today }
        if Calendar.current.isDateInToday(date) {
            return .today
        } else if Calendar.current.isDateInTomorrow(date) {
            return .tomorrow
        } else {
            return .custom(model: .init(date: date))
        }
    }
    var date: Date? {
        request.getDate()
    }
    var eventId: String {
        request.id
    }
    @Published private var request = NewEventRequest(id: UUID().uuidString)
    @Published var showProgress: Bool = false
    var isReady: Bool {
        guard let date = request.date, !date.isEmpty, request.game != nil
        else { return false }
        
        return true
    }
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store, eventService: EventServiceType) {
        self.store = store
        self.eventService = eventService
    }
    
    // MARK: - Methods
    
    func tryFetchOftenData() {
        Task {
            do {
                let data = try await eventService.fetchOftenData()
                await MainActor.run {
                    games = data.games.map({ NewEventGameCellViewModel(model: $0, isSelected: false, selectAction: nil)})
                    if let game = data.games.first {
                        didSelectGame(game)
                    }
                    members = data.members.map({ NewEventMemberCellViewModel(model: $0, isSelected: false, selectAction: nil)})
                    request.setTime(data.time ?? GlobalConstant.defaultEventTime)
                }
            } catch {
                await MainActor.run {
                    store.dispatch(.showNetworkError(EventServiceError.fetchOftenData))
                    games = []
                    members = []
                    request.setTime(GlobalConstant.defaultEventTime)
                }
            }
        }
    }
    
    func tryCreateEvent() {
        AnalyticsService.sendEvent(.submitCreateNewEvent)
        showProgress = true
        Task {
            do {
                try await eventService.createNewEvent(request)
                await MainActor.run {
                    showProgress = false
                    close?()
                }
            } catch {
                await MainActor.run {
                    showProgress = false
                    store.dispatch(.showNetworkError(EventServiceError.createEvent))
                }
            }
        }
    }
    
    func didSelectGame(_ game: Game) {
        guard var games else { return }
        
        games = games.map({
            var item = $0
            item.isSelected = false
            return item
        })
        if let index = games.firstIndex(where: { $0.model == game }) {
            var viewModel = games[index]
            viewModel.isSelected = true
            games[index] = viewModel
        } else {
            let newViewModel = NewEventGameCellViewModel(model: game, isSelected: true, selectAction: nil)
            games.insert(newViewModel, at: 0)
        }
        self.games = games
        request.game = game
    }
    
    func didSelectMember(_ member: User, forceSelect: Bool = false) {
        if let index = members?.firstIndex(where: { $0.model == member }), var viewModel = members?[index] {
            viewModel.isSelected = forceSelect ? true : !viewModel.isSelected
            members?[index] = viewModel
        } else {
            let newViewModel = NewEventMemberCellViewModel(model: member, isSelected: true, selectAction: nil)
            members?.insert(newViewModel, at: 0)
        }
        let selectedMembers = members?.filter({ $0.isSelected }).map({ $0.model }) ?? []
        request.members = selectedMembers
    }
    
    func didSelectMembers(_ selectedMembers: [User]) {
        members = members?.map({
            var item = $0
            item.isSelected = false
            return item
        })
        selectedMembers.forEach { didSelectMember($0, forceSelect: true)
        }
    }
    
    func didSelectDay(_ dayDate: DayDate) {
        switch dayDate {
        case .today:
            request.setDate(Date())
        case .tomorrow:
            request.setDate(Date() + 1.days)
        case .custom:
            break
        }
    }
    
    func didSelectTime(_ time: Date) {
        request.setTime(time)
    }
    
    func didSelectCustomDate(_ date: Date) {
        request.setDate(date)
    }
}
