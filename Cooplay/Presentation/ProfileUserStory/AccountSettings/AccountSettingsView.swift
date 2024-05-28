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
                linkItem(icon: Image(.commonAppleIcon), title: Localizable.accountLinkTitleApple())
                    .onTapGesture { state.linkAppleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink {
                linkItem(
                    icon: Image(.commonAppleIcon),
                    title: Localizable.accountUnlinkTitleApple(),
                    email: state.appleEmail
                )
                .onTapGesture { showUnlinkAppleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showLinkGoogle {
                linkItem(icon: Image(.commonGoogleIcon), title: Localizable.accountLinkTitleGoogle())
                    .onTapGesture { state.linkGoogleAccount() }
                ProfileSettingsSeparator()
            } else if state.showUnlink  {
                linkItem(
                    icon: Image(.commonGoogleIcon),
                    title: Localizable.accountUnlinkTitleGoogle(),
                    email: state.googleEmail
                )
                .onTapGesture { showUnlinkGoogleAlert = true }
                ProfileSettingsSeparator()
            }
            if state.showChangePassword {
                ProfileSettingsItemView(item: .changePassword)
                    .onTapGesture { coordinator.open(.changePassword) }
            } else {
                ProfileSettingsItemView(item: .addPassword)
                    .onTapGesture { coordinator.open(.addPassword) }
            }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .delete)
            Spacer()
        }
        .animation(.customTransition, value: state.providers)
        .activityIndicator(isShown: $state.showProgress)
        .alert(Localizable.accountUnlinkAlertApple(), isPresented: $showUnlinkAppleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountUnlinkAlertAction(), role: .destructive) {
                state.unlinkProvider(.apple)
            }
        })
        .alert(Localizable.accountUnlinkAlertAction(), isPresented: $showUnlinkGoogleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.accountUnlinkAlertAction(), role: .destructive) {
                state.unlinkProvider(.google)
            }
        })
    }
    
    func linkItem(icon: Image, title: String, email: String? = nil) -> some View {
        HStack {
            ZStack {
                Circle().foregroundStyle(Color(.textPrimary))
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
                if let email = email {
                    Text(email)
                        .foregroundColor(Color(.textSecondary))
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            Spacer()
            Image(.profileSettingsActionTypeSheet)
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(Color(R.color.textSecondary.name))
        }
        .contentShape(Rectangle())
        .padding(EdgeInsets(top: 9, leading: 24, bottom: 9, trailing: 24))
    }
    
}
