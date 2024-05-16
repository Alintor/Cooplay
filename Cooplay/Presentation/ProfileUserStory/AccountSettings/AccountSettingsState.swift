//
//  AccountSettingsState.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

final class AccountSettingsState: ObservableObject {
    
    // MARK: - Properties
    
    private let userService: UserServiceType
    @Published private var providers = [AuthProvider]()
    var showChangePassword: Bool {
        providers.contains { $0 == .password }
    }
    
    // MARK: - Init
    
    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func checkProviders() {
        providers = userService.getUserProviders()
    }
}
