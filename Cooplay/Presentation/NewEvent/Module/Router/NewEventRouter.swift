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
    
    func showTimePicker(startTime: Date, handler: ((_ date: Date) -> Void)?) {
        guard let delegate = transitionHandler as? NewEventTimePickerViewDelegate else { return }
        let timePickerView = NewEventTimePickerView(delegate: delegate, timeHandler: handler)
        timePickerView.show(startTime: startTime)
    }
    
    func openGameSearch(offtenGames: [Game]?, selectionHandler: ((_ game: Game) -> Void)?) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let searchGameViewController = R.storyboard.searchGame.searchGameViewController()!
        searchGameViewController.output?.configure(offtenGames: offtenGames, selectionHandler: selectionHandler)
        let navigationController = UINavigationController(rootViewController: searchGameViewController)
        transitionHandler.present(navigationController, animated: true, completion: nil)
    }
    
    func openMembersSearch(offtenMembers: [User]?, selectedMembers: [User], selectionHandler: ((_ members: [User]) -> Void)?) {
        guard let transitionHandler = transitionHandler as? UIViewController else { return }
        let searchMembersViewController = R.storyboard.searchMembers.searchMembersViewController()!
        searchMembersViewController.output?.configure(
            offtenMembers: offtenMembers,
            selectedMembers: selectedMembers,
            selectionHandler: selectionHandler
        )
        let navigationController = UINavigationController(rootViewController: searchMembersViewController)
        transitionHandler.present(navigationController, animated: true, completion: nil)
    }
}
