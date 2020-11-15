//
//  NewEventRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventRouterInput: CloseableRouter, TimePickerRoutable, SearchGameRoutable {

    func showCalendar(selectedDate: Date?, handler: ((_ date: Date) -> Void)?)
    func openMembersSearch(eventId: String, offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?)
}
