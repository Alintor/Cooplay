//
//  AuthorizationView.swift
//  Cooplay
//
//  Created by Alexandr on 29.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    enum FocusedField {
        case email
        case password
    }
    
    @StateObject var state: LoginState
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            navigationView
            Spacer()
            if focusedField == nil {
                HStack {
                    Text(Localizable.loginTitle())
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color(.textPrimary))
                        .matchedGeometryEffect(id: Constants.navigationTitleEffectId, in: namespace.id)
                    Spacer()
                }
                .padding(.bottom, 32)
            }
            TextFieldView(
                text: $state.email,
                placeholder: Localizable.loginEmailPlaceholder(),
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                error: $state.emailError
            )
            .padding(.bottom, 12)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
            TextFieldView(
                text: $state.password,
                placeholder: Localizable.loginPasswordPlaceholder(),
                contentType: .password,
                isSecured: true,
                error: $state.passwordError
            )
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = nil
                guard state.isReady else { return }
                
                state.tryLogin()
            }
            HStack {
                Spacer()
                Button(Localizable.loginRecoveryPasswordButton()) {
                    focusedField = nil
                    state.sendResetEmail()
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 20))
                .disabled(!state.email.isEmail)
                .opacity(state.email.isEmail ? 1 : 0.5)
            }
            .padding(.bottom, 32)
            MainActionButton(Localizable.loginActionButton(), isDisabled: !state.isReady) {
                focusedField = nil
                state.tryLogin()
            }
            .matchedGeometryEffect(id: MatchedAnimations.loginButton.name, in: namespace.id)
            Spacer()
            HStack(spacing: 8) {
                Spacer()
                Text(Localizable.loginRegisterMessage())
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.textPrimary))
                Button(Localizable.loginRegisterMessageButton()) {
                    focusedField = nil
                    coordinator.openRegister(email: state.email)
                }
                .font(.system(size: 20))
                .foregroundStyle(Color(.actionAccent))
                Spacer()
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 24)
        .animation(.customTransition, value: focusedField)
        .activityIndicator(isShown: $state.showProgress)
    }
    
    // MARK: - Subviews
    
    var navigationView: some View {
        ZStack {
            HStack{
                Spacer()
                if focusedField != nil {
                    TitleView(text: Localizable.loginTitle())
                        .matchedGeometryEffect(id: Constants.navigationTitleEffectId, in: namespace.id)
                }
                Spacer()
            }
            HStack {
                BackCloseIcon(isBack: .constant(true))
                    .foregroundColor(Color(.textSecondary))
                    .frame(width: 32, height: 32, alignment: .center)
                    .onTapGesture {
                        focusedField = nil
                        coordinator.backToMenu()
                    }
                Spacer()
            }
        }
    }
    
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitleEffectId = "titleLogin"
}
