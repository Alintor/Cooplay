//
//  PersonalisationAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Swinject
import SwinjectStoryboard

final class PersonalisationAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(PersonalisationInteractor.self) { r in
            let interactor = PersonalisationInteractor(userService: r.resolve(UserServiceType.self))

			return interactor
		}

		container.register(PersonalisationRouter.self) { (_, viewController: PersonalisationViewController) in
			let router = PersonalisationRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(PersonalisationPresenter.self) { (r, viewController: PersonalisationViewController) in
			let presenter = PersonalisationPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(PersonalisationInteractor.self)
			presenter.router = r.resolve(PersonalisationRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(PersonalisationViewController.self) { r, viewController in
			viewController.output = r.resolve(PersonalisationPresenter.self, argument: viewController)
		}
	}
}
