//
//  EventDetailsAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15/01/2020.
//

import Swinject
import SwinjectStoryboard

final class EventDetailsAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(EventDetailsInteractor.self) { r in
			let interactor = EventDetailsInteractor(eventService: r.resolve(EventServiceType.self))

			return interactor
		}

		container.register(EventDetailsRouter.self) { (_, viewController: EventDetailsViewController) in
			let router = EventDetailsRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(EventDetailsPresenter.self) { (r, viewController: EventDetailsViewController) in
			let presenter = EventDetailsPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(EventDetailsInteractor.self)
			presenter.router = r.resolve(EventDetailsRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(EventDetailsViewController.self) { r, viewController in
			viewController.output = r.resolve(EventDetailsPresenter.self, argument: viewController)
		}
	}
}
