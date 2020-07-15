//
//  EventsListAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 04/10/2019.
//

import Swinject
import SwinjectStoryboard

final class EventsListAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(EventsListInteractor.self) { r in
            let interactor = EventsListInteractor(
                eventService: r.resolve(EventServiceType.self),
                userService: r.resolve(UserServiceType.self),
                defaultsStorage: r.resolve(DefaultsStorageType.self)
            )

			return interactor
		}

		container.register(EventsListRouter.self) { (_, viewController: EventsListViewController) in
			let router = EventsListRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(EventsListPresenter.self) { (r, viewController: EventsListViewController) in
			let presenter = EventsListPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(EventsListInteractor.self)
			presenter.router = r.resolve(EventsListRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(EventsListViewController.self) { r, viewController in
			viewController.output = r.resolve(EventsListPresenter.self, argument: viewController)
		}
	}
}
