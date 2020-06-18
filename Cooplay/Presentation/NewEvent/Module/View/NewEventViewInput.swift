//
//  NewEventViewInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import UIKit

protocol NewEventViewInput: class, ActivityIndicatorRenderer {

    // MARK: - View out

    var output: NewEventModuleInput? { get set }
    var viewIsReady: (() -> Void)? { get set }
    var calendarAction: (() -> Void)? { get set }
    var timePickerAction: (() -> Void)? { get set }
    var searchGameAction: (() -> Void)? { get set }
    var searchMembersAction: (() -> Void)? { get set }
    var dateTodaySelected: (() -> Void)? { get set }
    var dateTomorrowSelected: (() -> Void)? { get set }
    var mainAction: (() -> Void)? { get set }

    // MARK: - View in

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
