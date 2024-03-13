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
    
    @Published var showChangePassword: Bool
    
    // MARK: - Init
    
    init() {
        self.showChangePassword = true
    }
    
}
