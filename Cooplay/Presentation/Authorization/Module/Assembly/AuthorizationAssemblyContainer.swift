//
//  AuthorizationAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Swinject
import SwinjectStoryboard

final class AuthorizationAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(AuthorizationInteractor.self) { r in
			let interactor = AuthorizationInteractor()

			return interactor
		}

		container.register(AuthorizationRouter.self) { (_, viewController: AuthorizationViewController) in
			let router = AuthorizationRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(AuthorizationPresenter.self) { (r, viewController: AuthorizationViewController) in
			let presenter = AuthorizationPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(AuthorizationInteractor.self)
			presenter.router = r.resolve(AuthorizationRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(AuthorizationViewController.self) { r, viewController in
			viewController.output = r.resolve(AuthorizationPresenter.self, argument: viewController)
		}
	}
}
