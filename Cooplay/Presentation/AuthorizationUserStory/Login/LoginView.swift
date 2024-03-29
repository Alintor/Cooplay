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
                    Text(Localizable.authorizationTitle())
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color(.textPrimary))
                        .matchedGeometryEffect(id: Constants.navigationTitleEffectId, in: namespace.id)
                    Spacer()
                }
                .padding(.bottom, 32)
            }
            TextFieldView(
                text: $state.email,
                placeholder: Localizable.authorizationEmailTextFieldPlaceholder(),
                keyboardType: .emailAddress,
                contentType: .emailAddress,
                showProgress: $state.showEmailChecking,
                error: $state.emailError
            )
            .padding(.bottom, 12)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
            TextFieldView(
                text: $state.password,
                placeholder: Localizable.authorizationPasswordTextFieldPlaceholder(),
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
                Button(Localizable.authorizationRecoveryPasswordButtonTitle()) {
                    focusedField = nil
                    state.sendResetEmail()
                }
                .foregroundStyle(Color(.actionAccent))
                .font(.system(size: 20))
                .disabled(!state.isEmailCorrect)
                .opacity(state.isEmailCorrect ? 1 : 0.5)
            }
            .padding(.bottom, 32)
            MainActionButton(Localizable.authorizationActionButtonTitle(), isDisabled: !state.isReady) {
                focusedField = nil
                state.tryLogin()
            }
            .matchedGeometryEffect(id: MatchedAnimations.loginButton.name, in: namespace.id)
            Spacer()
            HStack(spacing: 8) {
                Spacer()
                Text(Localizable.authorizationRegisterMessage())
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.textPrimary))
                Button(Localizable.authorizationMenuRegister()) {
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
        .onReceive(state.$email) { _ in
            state.checkEmail()
        }
    }
    
    // MARK: - Subviews
    
    var navigationView: some View {
        ZStack {
            HStack{
                Spacer()
                if focusedField != nil {
                    TitleView(text: Localizable.authorizationTitle())
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
