//
//  NotificationSettingsContract.swift
//  Cooplay
//
//  Created by Alexandr on 01/08/2023.
//

import Foundation

// MARK: - View

protocol NotificationSettingsViewInput: AnyObject {
    
}

protocol NotificationSettingsViewOutput: AnyObject {
    
    func didLoad()
}

// MARK: - Interactor

protocol NotificationSettingsInteractorInput: AnyObject { }

protocol NotificationSettingsInteractorOutput: AnyObject { }

// MARK: - Router

protocol NotificationSettingsRouterInput: AnyObject { }

// MARK: - ModuleInput

protocol NotificationSettingsModuleInput { }
