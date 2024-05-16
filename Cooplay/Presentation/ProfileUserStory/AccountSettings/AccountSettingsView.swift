//
//  AccountSettingsView.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @EnvironmentObject var state: AccountSettingsState
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: ProfileCoordinator
    
    var body: some View {
        VStack(spacing: 0) {
            if state.showChangePassword {
                ProfileSettingsItemView(item: .changePassword)
                    .onTapGesture { coordinator.open(.changePassword) }
                ProfileSettingsSeparator()
            }
            ProfileSettingsItemView(item: .delete)
            Spacer()
        }
        .animation(.customTransition, value: state.showChangePassword)
        .onAppear {
            state.checkProviders()
        }
    }
    
}
