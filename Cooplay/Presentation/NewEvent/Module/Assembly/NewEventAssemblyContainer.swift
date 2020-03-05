//
//  NewEventAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 20/01/2020.
//

import Swinject
import SwinjectStoryboard

final class NewEventAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(NewEventInteractor.self) { r in
            let interactor = NewEventInteractor(
                eventService: r.resolve(EventServiceType.self),
                userService: r.resolve(UserServiceType.self)
            )

			return interactor
		}

		container.register(NewEventRouter.self) { (_, viewController: NewEventViewController) in
			let router = NewEventRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(NewEventPresenter.self) { (r, viewController: NewEventViewController) in
			let presenter = NewEventPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(NewEventInteractor.self)
			presenter.router = r.resolve(NewEventRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(NewEventViewController.self) { r, viewController in
			viewController.output = r.resolve(NewEventPresenter.self, argument: viewController)
		}
	}
}
