//
//  EventsListRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Foundation

protocol EventsListRouterInput: ContextMenuRouter {

    func openEvent(_ event: Event)
    func openNewEvent()
    func openProfile(with user: Profile)
}
