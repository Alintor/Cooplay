//
//  AccountSettingsView.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @StateObject var state: AccountSettingsState
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: ProfileCoordinator
    @State private var showUnlinkAppleAlert = false
    @State private var showUnlinkGoogleAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            if state.showLinkApple {
                ProfileSettingsItemView(item: .linkApple)
                    .onTapGesture { state.linkAppleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink {
                ProfileSettingsItemView(item: .unlinkApple)
                    .onTapGesture { showUnlinkAppleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showLinkGoogle {
                ProfileSettingsItemView(item: .linkGoogle)
                    .onTapGesture { state.linkGoogleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink  {
                ProfileSettingsItemView(item: .unlinkGoogle)
                    .onTapGesture { showUnlinkGoogleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showChangePassword {
                ProfileSettingsItemView(item: .changePassword)
                    .onTapGesture { coordinator.open(.changePassword) }
            } else {
                ProfileSettingsItemView(item: .addPassword)
            }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .delete)
            Spacer()
        }
        .animation(.customTransition, value: state.providers)
        .activityIndicator(isShown: $state.showProgress)
        .alert(Localizable.accountAlertUnlinkApple(), isPresented: $showUnlinkAppleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountAlertUnlinkAction(), role: .destructive) {
                state.unlinkProvider(.apple)
            }
        })
        .alert(Localizable.accountAlertUnlinkGoogle(), isPresented: $showUnlinkGoogleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountAlertUnlinkAction(), role: .destructive) {
                state.unlinkProvider(.google)
            }
        })
    }
    
}
