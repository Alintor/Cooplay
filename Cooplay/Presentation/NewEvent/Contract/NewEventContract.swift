//
//  NewEventContract.swift
//  Cooplay
//
//  Created by Alexandr on 13.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import UIKit

// MARK: - View

protocol NewEventViewInput: AnyObject, ActivityIndicatorRenderer {

    func setupInitialState()
    func updateDayDate(with model: NewEventDayDateViewModel)
    func setGamesDataSource(_ dataSource: UICollectionViewDataSource)
    func showGames(_ isShow: Bool)
    func updateGames()
    func setMembersDataSource(_ dataSource: UICollectionViewDataSource)
    func showMembers(_ isShow: Bool)
    func updateMembers()
    func setTime(_ time: Date)
    func showLoading()
    func hideLoading()
    func setCreateButtonEnabled(_ isEnabled: Bool)
}

protocol NewEventViewOutput: AnyObject {
    
    func didLoad()
    func didTapCalendar()
    func didTapTime()
    func didTapToday()
    func didTapTomorrow()
    func didTapSearchGame()
    func didTapSearchMember()
    func didTapMainActionButton()
    func close()
}

// MARK: - Interactor

protocol NewEventInteractorInput: AnyObject {

    func isReady(_ request: NewEventRequest) -> Bool
    func fetchofftenData(
        completion: @escaping (Result<NewEventOftenDataResponse, NewEventError>) -> Void
    )
    func createNewEvent(_ request: NewEventRequest)
}

// MARK: - Router

protocol NewEventRouterInput: CloseableRouter, TimePickerRoutable, SearchGameRoutable {

    func showCalendar(selectedDate: Date?, handler: ((_ date: Date) -> Void)?)
    func openMembersSearch(
        eventId: String,
        offtenMembers: [User]?,
        selectedMembers: [User],
        selectionHandler: ((_ members: [User]) -> Void)?
    )
}

// MARK: - Module Input

protocol NewEventModuleInput: AnyObject {
    
    func configure(closeHandler: (() -> Void)?)
}
