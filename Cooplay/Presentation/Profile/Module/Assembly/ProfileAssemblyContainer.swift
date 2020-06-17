//
//  ProfileAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import Swinject
import SwinjectStoryboard

final class ProfileAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(ProfileInteractor.self) { r in
			let interactor = ProfileInteractor(
                authorizationService: r.resolve(AuthorizationServiceType.self)
            )

			return interactor
		}

		container.register(ProfileRouter.self) { (_, viewController: ProfileViewController) in
			let router = ProfileRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(ProfilePresenter.self) { (r, viewController: ProfileViewController) in
			let presenter = ProfilePresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(ProfileInteractor.self)
			presenter.router = r.resolve(ProfileRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(ProfileViewController.self) { r, viewController in
			viewController.output = r.resolve(ProfilePresenter.self, argument: viewController)
		}
	}
}
