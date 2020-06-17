//
//  RegistrationAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/05/2020.
//

import Swinject
import SwinjectStoryboard

final class RegistrationAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(RegistrationInteractor.self) { r in
			let interactor = RegistrationInteractor(
                authorizationService: r.resolve(AuthorizationServiceType.self)
            )

			return interactor
		}

		container.register(RegistrationRouter.self) { (_, viewController: RegistrationViewController) in
			let router = RegistrationRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(RegistrationPresenter.self) { (r, viewController: RegistrationViewController) in
			let presenter = RegistrationPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(RegistrationInteractor.self)
			presenter.router = r.resolve(RegistrationRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(RegistrationViewController.self) { r, viewController in
			viewController.output = r.resolve(RegistrationPresenter.self, argument: viewController)
		}
	}
}
