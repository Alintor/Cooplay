//
//  NewEventRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventRouterInput: CloseableRouter, TimePickerRoutable {

    func showCalendar(selectedDate: Date?, handler: ((_ date: Date) -> Void)?)
    func openGameSearch(offtenGames: [Game]?, selectionHandler: ((_ game: Game) -> Void)?)
    func openMembersSearch(eventId: String, offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?)
}
