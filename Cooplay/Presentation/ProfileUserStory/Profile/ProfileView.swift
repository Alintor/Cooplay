//
//  ProfileView.swift
//  Cooplay
//
//  Created by Alexandr on 03.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var state: ProfileState
    @EnvironmentObject var namespace: NamespaceWrapper
    @State private var canContinueOffset = true
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    @State var isBackButton: Bool = false
    
    var body: some View {
        ZStack {
            if let navigation = state.itemNavigation {
                VStack {
                    navigationView(title: navigation.title)
                    switch navigation {
                    case .edit:
                        ScreenViewFactory.editProfile(state.profile, needShowProfileAvatar: $state.isShownAvatar)
                    case .reactions:
                        ScreenViewFactory.reactionsSettings()
                    }
                }
                .closable(anchor: .trailing) {
                    state.itemNavigation = nil
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            } else {
                profileView
                    .zIndex(1)
                    .transition(.move(edge: .leading))
            }
            if state.showLogoutSheet {
                LogoutSheetView(showAlert: $state.showLogoutSheet) {
                    state.logout()
                }
            }
        }
        .animation(.customTransition, value: state.itemNavigation)
        .animation(.customTransition, value: isBackButton)
        .onReceive(state.$itemNavigation) { item in
            isBackButton = item != nil
        }
        .activityIndicator(isShown: $state.isInProgress)
        .fullScreenCover(isPresented: $state.isMinigamesShown) {
            ArcanoidView().ignoresSafeArea()
        }
    }
    
    // MARK: - Subviews
    
    func navigationView(title: String) -> some View {
        ZStack {
            HStack{
                Spacer()
                TitleView(text: title)
                Spacer()
            }
            HStack {
                BackCloseIcon(isBack: $isBackButton)
                    .foregroundColor(Color.r.textSecondary.color)
                    .matchedGeometryEffect(id: MatchedAnimations.closeButton.name, in: namespace.id)
                    .frame(width: 32, height: 32, alignment: .center)
                    .onTapGesture {
                        state.itemNavigation = nil
                    }
                Spacer()
            }
        }
        .padding()
    }
    
    var profileView: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    ProfileInfoView()
                        .handleScroll(coordinateSpaceName: Constant.profileCoordinateSpaceName) { rect in
                            guard canContinueOffset else { return }
                            let offset = rect.origin.y - 48
                            if offset >= 100 {
                                canContinueOffset = false
                                generator.prepare()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    generator.impactOccurred()
                                    state.isShown?.wrappedValue = false
                                }
                            }
                        }
                        .padding(.bottom, 24)
                        .padding(.top, 48)
                    settingsList
                }
            }
            .coordinateSpace(name: Constant.profileCoordinateSpaceName)
            VStack {
                HStack {
                    Spacer()
                    BackCloseIcon(isBack: $isBackButton)
                        .foregroundColor(Color.r.textSecondary.color)
                        .matchedGeometryEffect(id: MatchedAnimations.closeButton.name, in: namespace.id)
                        .frame(width: 32, height: 32, alignment: .center)
                        .padding()
                        .onTapGesture {
                            state.isShown?.wrappedValue = false
                        }
                }
                Spacer()
            }
        }
        .closable(anchor: .topTrailing) {
            state.isShown?.wrappedValue = false
        }
    }
    
    var settingsList: some View {
        ForEach(ProfileSettingsItem.Section.allCases) { sectionItem in
            if !sectionItem.title.isEmpty {
                ProfileSettingsSectionHeader(title: sectionItem.title)
            }
            if let items = state.settings[sectionItem] {
                ForEach(items, id:\.self) { item in
                    ProfileSettingsItemView(item: item)
                        .onTapGesture { state.itemSelected(item) }
                    if item != items.last {
                        ProfileSettingsSeparator()
                    }
                }
            }
        }
    }
    
}


private enum Constant {
    
    static let profileCoordinateSpaceName = "CoordinateSpace.profile"
}
