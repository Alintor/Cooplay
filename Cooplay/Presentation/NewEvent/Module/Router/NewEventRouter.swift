//
//  NewEventRouter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import LightRoute

final class NewEventRouter {

    weak var transitionHandler: TransitionHandler!
}

// MARK: - NewEventRouterInput

extension NewEventRouter: NewEventRouterInput {

    func showCalendar(handler: ((_ date: Date) -> Void)?) {
        let calendarRenderer = CalendarViewRenderer()
        calendarRenderer.show(handler: handler)
    }
}
