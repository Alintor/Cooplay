//
//  IntroPresenter.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 22/04/2020.
//

import Foundation

final class IntroPresenter {

    // MARK: - Properties

    private weak var view: IntroViewInput!
    private let interactor: IntroInteractorInput
    private let router: IntroRouterInput
    
    // MARK: - Init
    
    init(
        view: IntroViewInput!,
        interactor: IntroInteractorInput,
        router: IntroRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - IntroViewOutput

extension IntroPresenter: IntroViewOutput {
    
    func didLoad() {
        view.setupInitialState()
    }
    
    func didTapAuth() {
        router.openAuthorization()
    }
    
    func didTapRegister() {
        router.openRegistration()
    }

}

// MARK: - IntroModuleInput

extension IntroPresenter: IntroModuleInput { }
