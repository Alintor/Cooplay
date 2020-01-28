//
//  NewEventRouterInput.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Foundation

protocol NewEventRouterInput {

    func showCalendar(handler: ((_ date: Date) -> Void)?)
    func openGameSearch()
}
