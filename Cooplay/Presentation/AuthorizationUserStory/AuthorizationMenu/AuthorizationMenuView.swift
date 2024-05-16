//
//  AuthorizationMenuView.swift
//  Cooplay
//
//  Created by Alexandr on 30.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AuthorizationMenuView: View {
    
    @StateObject var state: AuthorizationMenuState
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack {
            Spacer()
            Image(.commonLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Spacer()
            Button {
                print("APPLE")
            } label: {
                HStack {
                    Spacer()
                    Image(.commonAppleIcon)
                        .frame(width: 24, height: 24)
                    Text(Localizable.authorizationMenuApple())
                        .foregroundColor(Color(.background))
                        .font(.system(size: 17))
                    Spacer()
                }
                .padding(16)
            }
            .background(Color(.textPrimary))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .padding(.bottom, 16)
            Button {
                state.signWithGoogle()
            } label: {
                HStack {
                    Spacer()
                    Image(.commonGoogleIcon)
                        .frame(width: 24, height: 24)
                    Text(Localizable.authorizationMenuGoogle())
                        .foregroundColor(Color(.background))
                        .font(.system(size: 17))
                    Spacer()
                }
                .padding(16)
            }
            .background(Color(.textPrimary))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .padding(.bottom, 32)
            Text(Localizable.authorizationMenuOr())
                .foregroundColor(Color(.textSecondary))
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
            MainActionButton(Localizable.authorizationMenuLogin()) {
                coordinator.openLogin()
            }
            .matchedGeometryEffect(id: MatchedAnimations.loginButton.name, in: namespace.id)
            .padding(.bottom, 16)
            Button {
                coordinator.openRegister()
            } label: {
                Text(Localizable.authorizationMenuRegister())
                    .foregroundColor(Color(.actionAccent))
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(16)
            }
            .background(Color(.block))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .matchedGeometryEffect(id: MatchedAnimations.registerButton.name, in: namespace.id)
            .padding(.bottom, 80)
        }
        .padding(.horizontal, 24)
        .activityIndicator(isShown: $state.showProgress)
    }
}
