//
//  SearchMembersAssemblyContainer.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 14/02/2020.
//

import Swinject
import SwinjectStoryboard

final class SearchMembersAssemblyContainer: Assembly {

	func assemble(container: Container) {
		container.register(SearchMembersInteractor.self) { r in
			let interactor = SearchMembersInteractor()

			return interactor
		}

		container.register(SearchMembersRouter.self) { (_, viewController: SearchMembersViewController) in
			let router = SearchMembersRouter()
			router.transitionHandler = viewController

			return router
		}

		container.register(SearchMembersPresenter.self) { (r, viewController: SearchMembersViewController) in
			let presenter = SearchMembersPresenter()
			presenter.view = viewController
			presenter.interactor = r.resolve(SearchMembersInteractor.self)
			presenter.router = r.resolve(SearchMembersRouter.self, argument: viewController)

			return presenter
		}

		container.storyboardInitCompleted(SearchMembersViewController.self) { r, viewController in
			viewController.output = r.resolve(SearchMembersPresenter.self, argument: viewController)
		}
	}
}
