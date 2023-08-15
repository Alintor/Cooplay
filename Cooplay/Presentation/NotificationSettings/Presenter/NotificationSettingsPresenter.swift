//
//  NotificationSettingsPresenter.swift
//  Cooplay
//
//  Created by Alexandr on 01/08/2023.
//

import Foundation

final class NotificationSettingsPresenter {

    // MARK: - Properties

    private weak var view: NotificationSettingsViewInput?
    private var interactor: NotificationSettingsInteractorInput
    private var router: NotificationSettingsRouterInput

    // MARK: - Init
    
    init(
        view: NotificationSettingsViewInput?,
        interactor: NotificationSettingsInteractorInput,
        router: NotificationSettingsRouterInput
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

}

// MARK: - NotificationSettingsViewOutput

extension NotificationSettingsPresenter: NotificationSettingsViewOutput {
    
    func didLoad() { }
    
}

// MARK: - NotificationSettingsInteractorOutput

extension NotificationSettingsPresenter: NotificationSettingsInteractorOutput { }

// MARK: - NotificationSettingsModuleInput

extension NotificationSettingsPresenter: NotificationSettingsModuleInput {

}
