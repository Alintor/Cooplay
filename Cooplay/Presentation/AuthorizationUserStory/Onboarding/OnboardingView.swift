//
//  OnboardingView.swift
//  Cooplay
//
//  Created by Alexandr on 01.08.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.commonLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .matchedGeometryEffect(id: MatchedAnimations.logo.name, in: namespace.id)
                .frame(width: 120, height: 32)
                .padding(.top, 24)
            OnboardingCardView()
                .padding(.top, 64)
            Text(Localizable.onboardingTitle())
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .multilineTextAlignment(.center)
                .padding(.top, 32)
            Text(Localizable.onboardingMessage())
                .font(.system(size: 17))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
                .padding(.top, 8)
            Spacer()
            MainActionButton(Localizable.onboardingActionButton()) {
                coordinator.backToMenu(isStart: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    Haptic.play(style: .soft)
                }
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
    }
}
