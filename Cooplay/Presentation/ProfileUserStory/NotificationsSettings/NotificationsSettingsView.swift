//
//  NotificationsSettingsView.swift
//  Cooplay
//
//  Created by Alexandr on 12.04.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NotificationsSettingsView: View {
    
    @StateObject var state: NotificationsSettingsState
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ScrollView {
            VStack {
                if state.showPermissionView {
                    permissionView
                }
                itemView(
                    inOn: $state.notificationsInfo.enableNotifications,
                    title: Localizable.notificationsSettingsItemsEnableNotificationsTitle(),
                    message: Localizable.notificationsSettingsItemsEnableNotificationsMessage()
                )
                VStack {
                    itemView(
                        inOn: $state.notificationsInfo.needStatusChange,
                        title: Localizable.notificationsSettingsItemsNeedStatusChangeTitle(),
                        message: Localizable.notificationsSettingsItemsNeedStatusChangeMessage()
                    )
                    itemView(
                        inOn: $state.notificationsInfo.needReactionsForMe,
                        title: Localizable.notificationsSettingsItemsNeedReactionsForMeTitle(),
                        message: Localizable.notificationsSettingsItemsNeedReactionsForMeMessage()
                    )
                    itemView(
                        inOn: $state.notificationsInfo.needOtherReactions,
                        title: Localizable.notificationsSettingsItemsNeedOtherReactionsTitle(),
                        message: Localizable.notificationsSettingsItemsNeedOtherReactionsMessage()
                    )
                }
                .disabled(!state.notificationsInfo.enableNotifications)
                .opacity(state.notificationsInfo.enableNotifications ? 1 : 0.5)
            }
            .padding(.horizontal, 24)
        }
        .animation(.customTransition, value: state.notificationsInfo)
        .animation(.customTransition, value: state.showPermissionView)
        .onChange(of: state.notificationsInfo) { _ in
            state.updateInfo()
        }
        .onAppear {
            state.checkPermissions()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                state.checkPermissions()
            }
        }
    }
    
    func itemView(inOn: Binding<Bool>, title: String, message: String) -> some View {
        VStack {
            Toggle(isOn: inOn) {
                Text(title)
                    .font(.system(size: 17, weight:.semibold))
                    .foregroundStyle(Color(.textPrimary))
            }
            .tint(Color(.actionAccent))
            Text(message)
                .foregroundStyle(Color(.textSecondary))
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            Divider()
                .padding(.vertical, 16)
        }
    }
    
    var permissionView: some View {
        VStack {
            HStack(spacing: 16) {
                Image(.commonAttention)
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(.red))
                Text(Localizable.notificationsSettingsPermissionsMessage())
                    .foregroundStyle(Color(.textPrimary))
                    .font(.system(size: 13))
            }
            .padding(16)
            Button(Localizable.notificationsSettingsPermissionsAction()) {
                state.openSettings()
            }
            .foregroundStyle(Color(.actionAccent))
            .font(.system(size: 15, weight: .semibold))
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .padding(.bottom, 8)
    }
    
}
