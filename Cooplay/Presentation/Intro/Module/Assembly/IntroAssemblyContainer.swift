//
//  IntroAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Swinject
import SwinjectStoryboard

final class IntroAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(IntroInteractor.self) { r in
			let interactor = IntroInteractor()

			return interactor
		}

		container.register(IntroRouter.self) { (_, viewController: IntroViewController) in
			let router = IntroRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(IntroPresenter.self) { (r, viewController: IntroViewController) in
			let presenter = IntroPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(IntroInteractor.self)
			presenter.router = r.resolve(IntroRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(IntroViewController.self) { r, viewController in
			viewController.output = r.resolve(IntroPresenter.self, argument: viewController)
		}
	}
}
