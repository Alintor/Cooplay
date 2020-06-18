//
//  NewEventRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventRouterInput: CloseableRouter {

    func showCalendar(selectedDate: Date?, handler: ((_ date: Date) -> Void)?)
    func showTimePicker(startTime: Date, enableMinimumTime: Bool, handler: ((_ date: Date) -> Void)?)
    func openGameSearch(offtenGames: [Game]?, selectionHandler: ((_ game: Game) -> Void)?)
    func openMembersSearch(offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?)
}
