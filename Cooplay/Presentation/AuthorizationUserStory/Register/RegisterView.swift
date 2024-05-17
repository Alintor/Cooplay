//
//  RegisterView.swift
//  Cooplay
//
//  Created by Alexandr on 12.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    
    enum FocusedField {
        case email
        case password
        case confirmPassword
    }
    
    @StateObject var state: RegisterState
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            navigationView
            Spacer()
            if focusedField == nil {
                HStack {
                    Text(Localizable.registrationTitle())
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Color(.textPrimary))
                        .matchedGeometryEffect(id: Constants.navigationTitleEffectId, in: namespace.id)
                    Spacer()
                }
                .padding(.bottom, 32)
            }
            TextFieldView(
                text: $state.email,
                placeholder: Localizable.registrationEmailTextFieldPlaceholder(),
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
                placeholder: Localizable.registrationPasswordTextFieldPlaceholder(),
                contentType: .password,
                isSecured: true,
                error: $state.passwordError
            )
            .padding(.bottom, 12)
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
            TextFieldView(
                text: $state.confirmPassword,
                placeholder: Localizable.registrationPasswordConfirmTextFieldPlaceholder(),
                contentType: .password,
                isSecured: true,
                error: $state.confirmPasswordError
            )
            .padding(.bottom, 12)
            .focused($focusedField, equals: .confirmPassword)
            .onSubmit {
                focusedField = nil
                guard state.isReady else { return }
                
                state.tryRegister()
            }
            MainActionButton(Localizable.registrationActionButtonTitle(), isDisabled: !state.isReady) {
                focusedField = nil
                state.tryRegister()
            }
            .matchedGeometryEffect(id: MatchedAnimations.registerButton.name, in: namespace.id)
            Spacer()
            HStack(spacing: 8) {
                Spacer()
                Text(Localizable.registrationLoginMessage())
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.textPrimary))
                Button(Localizable.authorizationMenuLogin()) {
                    focusedField = nil
                    coordinator.openLogin(email: state.email)
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
        .onReceive(state.$password) { _ in
            state.checkPassword()
            state.checkConfirmPassword()
        }
        .onReceive(state.$confirmPassword) { _ in
            state.checkConfirmPassword()
        }
    }
    
    // MARK: - Subviews
    
    var navigationView: some View {
        ZStack {
            HStack{
                Spacer()
                if focusedField != nil {
                    TitleView(text: Localizable.registrationTitle())
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
    
    static let navigationTitleEffectId = "titleRegister"
}
