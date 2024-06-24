//
//  HomeNavigationBar.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeNavigationBar: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: HomeCoordinator
    @State private var logoTapCount = 0
    @State private var timer: Timer?
    var logoScale: CGFloat {
        switch logoTapCount {
        case 1: return 1.1
        case 2: return 1.2
        case 3: return 1.3
        case 4: return 1.4
        case 5: return 1.5
        default: return 1
        }
    }
    var logoAngle: CGFloat {
        switch logoTapCount {
        case 1: return 3
        case 2: return -5
        case 3: return 7
        case 4: return -9
        case 5: return 11
        default: return 1
        }
    }
    
    var body: some View {
        ZStack {
            if coordinator.showLoadingIndicator {
                HomeLoadingIndicator()
                    .transition(.opacity)
            }
            HStack {
                eventsIcon
                    .padding()
                    .contentShape(Rectangle())
                    .scaleEffect(logoScale, anchor: .center)
                    .rotationEffect(.degrees(logoAngle), anchor: .center)
                    .onTapGesture {
                        if coordinator.isActiveEventPresented {
                            coordinator.deselectEvent()
                        } else {
                            handleTapLogo()
                        }
                    }
                if coordinator.isActiveEventPresented {
                    Spacer()
                }
                Image(R.image.commonLogoText.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 16)
                    .clipped()
                    .padding(.leading, coordinator.isActiveEventPresented ? 0 : -16)
                Spacer()
                if let profile = coordinator.profile, !coordinator.hideProfile {
                    AvatarItemView(viewModel: .init(with: profile.user), diameter: 32)
                        .frame(width: 32, height: 32, alignment: .center)
                        .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace.id)
                        .padding()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.show(.profile)
                        }
                }
            }
        }
        .background {
            TransparentBlurView(removeAllFilters: false)
                .blur(radius: 15)
                .padding([.horizontal, .top], -30)
                .frame(width: UIScreen.main.bounds.size.width)
                .opacity(coordinator.isActiveEventPresented ? 0 : 1)
                .ignoresSafeArea()
        }
        .animation(.customTransition, value: coordinator.showLoadingIndicator)
        .animation(.bounceTransition, value: logoTapCount)
        .onChange(of: coordinator.isActiveEventPresented) { _ in
            logoTapCount = 0
            timer?.invalidate()
        }
        .onAppear {
            timer?.invalidate()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    var eventsIcon: some View {
        ZStack {
            if coordinator.invitesCount > 0 && coordinator.isActiveEventPresented {
                InvitesIconView(count: coordinator.invitesCount)
                    .frame(width: 32, height: 32)
                    .zIndex(1)
                    .transition(.scale)
            } else {
                Image(R.image.commonLogoIcon.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(coordinator.isActiveEventPresented ? Color(.textPrimary) : Color(.actionAccent))
                    .frame(width: 32, height: 32)
                    .clipped()
                    .matchedGeometryEffect(id: MatchedAnimations.logo.name, in: namespace.id)
                    .rotationEffect(.degrees(coordinator.isActiveEventPresented ? -180 : 0))
                    .zIndex(1)
                    .transition(.scale)
            }
        }
    }
    
    private func handleTapLogo() {
        AnalyticsService.sendEvent(.tapLogo)
        logoTapCount += 1
        switch logoTapCount {
        case 1: Haptic.play(style: .soft)
        case 2: Haptic.play(style: .light)
        case 3: Haptic.play(style: .rigid)
        case 4: Haptic.play(style: .medium)
        case 5: Haptic.play(style: .heavy)
        default: break
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            logoTapCount = 0
            timer.invalidate()
        }
        guard logoTapCount >= Constants.logoTapTriggerCount else { return }
        
        logoTapCount = 0
        timer?.invalidate()
        coordinator.showLogoSpinner = true
    }
    
}

// MARK - Constants

private enum Constants {
    
    static let logoTapTriggerCount = 5
}
