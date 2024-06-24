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
                linkItem(
                    icon: Image(.commonAppleIcon),
                    title: Localizable.accountLinkTitleApple(),
                    message: Localizable.accountLinkMessage()
                )
                .onTapGesture { state.linkAppleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink {
                linkItem(
                    icon: Image(.commonAppleIcon),
                    title: Localizable.accountUnlinkTitleApple(),
                    message: state.appleEmail
                )
                .onTapGesture { showUnlinkAppleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showLinkGoogle {
                linkItem(
                    icon: Image(.commonGoogleIcon),
                    title: Localizable.accountLinkTitleGoogle(),
                    message: Localizable.accountLinkMessage()
                )
                .onTapGesture { state.linkGoogleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink  {
                linkItem(
                    icon: Image(.commonGoogleIcon),
                    title: Localizable.accountUnlinkTitleGoogle(),
                    message: state.googleEmail
                )
                .onTapGesture { showUnlinkGoogleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showChangePassword {
                ProfileSettingsItemView(item: .changePassword)
                    .onTapGesture {
                        AnalyticsService.sendEvent(.openChangePasswordScreen)
                        coordinator.open(.changePassword)
                    }
            } else {
                linkItem(
                    icon: Image(.profileSettingsChangePassword),
                    iconColor: Color(.profileSettingsChangePassword),
                    title: Localizable.accountAddPasswordTitle(),
                    message: Localizable.accountAddPasswordMessage(),
                    isSheet: false
                )
                .onTapGesture {
                    AnalyticsService.sendEvent(.openAddPasswordScreen)
                    coordinator.open(.addPassword)
                }
            }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .delete)
                .onTapGesture {
                    AnalyticsService.sendEvent(.openDeleteAccountScreen)
                    coordinator.open(.deleteAccount)
                }
            Spacer()
        }
        .animation(.customTransition, value: state.providers)
        .activityIndicator(isShown: $state.showProgress)
        .alert(Localizable.accountUnlinkAlertApple(), isPresented: $showUnlinkAppleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountUnlinkAlertAction(), role: .destructive) {
                AnalyticsService.sendEvent(.tapUnlinkApple)
                state.unlinkProvider(.apple)
            }
        })
        .alert(Localizable.accountUnlinkAlertGoogle(), isPresented: $showUnlinkGoogleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountUnlinkAlertAction(), role: .destructive) {
                AnalyticsService.sendEvent(.tapUnlinkGoogle)
                state.unlinkProvider(.google)
            }
        })
    }
    
    func linkItem(icon: Image, iconColor: Color = Color(.textPrimary), title: String, message: String? = nil, isSheet: Bool = true) -> some View {
        HStack {
            ZStack {
                Circle().foregroundStyle(iconColor)
                icon
                    .frame(width: 20, height: 20, alignment: .center)
                    .cornerRadius(15, antialiased: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
            }
            .frame(width: 30, height: 30, alignment: .center)
            .padding(.trailing, 6)
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color(.textPrimary))
                    .font(.system(size: 17, weight: .semibold))
                if let message = message {
                    Text(message)
                        .foregroundColor(Color(.textSecondary))
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            Spacer()
            Image(isSheet ? .profileSettingsActionTypeSheet : .profileSettingsActionTypeNavigation)
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(Color(R.color.textSecondary.name))
        }
        .contentShape(Rectangle())
        .padding(EdgeInsets(top: 9, leading: 24, bottom: 9, trailing: 24))
    }
    
}
