//
//  ProfileMenuView.swift
//  Cooplay
//
//  Created by Alexandr on 29.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileMenuView: View {
    
    @EnvironmentObject var state: ProfileMenuState
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: ProfileCoordinator
    @State private var canContinueOffset = true
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ProfileInfoView()
                        .handleRect(in: .named(GlobalConstant.CoordinateSpace.profile)) { rect in
                            guard canContinueOffset else { return }
                            let offset = rect.origin.y - 48
                            if offset >= 100 {
                                canContinueOffset = false
                                generator.prepare()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    generator.impactOccurred()
                                    coordinator.close?()
                                }
                            }
                        }
                        .padding(.bottom, 24)
                        .padding(.top, 48)
                    settingsList
                }
            }
            .coordinateSpace(name: GlobalConstant.CoordinateSpace.profile)
            VStack {
                HStack {
                    Spacer()
                    BackCloseIcon(isBack: state.isBackButton)
                        .foregroundColor(Color(.textSecondary))
                        .matchedGeometryEffect(id: MatchedAnimations.closeButton.name, in: namespace.id)
                        .frame(width: 32, height: 32, alignment: .center)
                        .padding()
                        .onTapGesture {
                            coordinator.close?()
                        }
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Subviews
    
    var settingsList: some View {
        VStack(spacing: 0) {
            ProfileSettingsItemView(item: .edit)
                .onTapGesture { coordinator.open(.editProfile) }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .miniGames)
                .onTapGesture { coordinator.showArkanoidGame() }
            ProfileSettingsSectionHeader(title: Localizable.profileSettingsSectionSettingsTitle())
            ProfileSettingsItemView(item: .notifications)
                .onTapGesture { coordinator.open(.notifications) }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .reactions)
                .onTapGesture { coordinator.open(.reactions) }
            ProfileSettingsSectionHeader(title: Localizable.profileSettingsSectionFeedbackTitle())
            ProfileSettingsItemView(item: .rateApp)
                .onTapGesture { coordinator.openRateApp() }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .writeToUs)
                .onTapGesture { coordinator.open(.writeToUs) }
            ProfileSettingsSectionHeader(title: Localizable.profileSettingsSectionAccountTitle())
            ProfileSettingsItemView(item: .account)
                .onTapGesture { coordinator.open(.account(isBack: false)) }
            ProfileSettingsSeparator()
            ProfileSettingsItemView(item: .logout)
                .onTapGesture { coordinator.showLogoutSheet() }
        }
    }
    
}
