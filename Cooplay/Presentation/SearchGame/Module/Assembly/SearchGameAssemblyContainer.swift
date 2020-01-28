//
//  SearchGameAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 27/01/2020.
//

import Swinject
import SwinjectStoryboard

final class SearchGameAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(SearchGameInteractor.self) { r in
			let interactor = SearchGameInteractor()

			return interactor
		}

		container.register(SearchGameRouter.self) { (_, viewController: SearchGameViewController) in
			let router = SearchGameRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(SearchGamePresenter.self) { (r, viewController: SearchGameViewController) in
			let presenter = SearchGamePresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(SearchGameInteractor.self)
			presenter.router = r.resolve(SearchGameRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(SearchGameViewController.self) { r, viewController in
			viewController.output = r.resolve(SearchGamePresenter.self, argument: viewController)
		}
	}
}
