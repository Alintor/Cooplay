//
//  ResetPasswordView.swift
//  Cooplay
//
//  Created by Alexandr on 19.04.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ResetPasswordView: View {
    
    enum FocusedField {
        case newPassword
        case confirmPassword
    }
    
    @StateObject var state: ResetPasswordState
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            navigationView
            Spacer()
            if state.showExpiredView {
                expiredView
            } else {
                if focusedField == nil {
                    HStack {
                        Text(Localizable.resetPasswordTitle())
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color(.textPrimary))
                            .matchedGeometryEffect(id: Constants.navigationTitleEffectId, in: namespace.id)
                        Spacer()
                    }
                    .padding(.bottom, 8)
                }
                if let email = state.email {
                    (Text(Localizable.resetPasswordMessage()) + Text(" ") + Text(email).bold())
                        .font(.system(size: 17))
                        .foregroundStyle(Color(.textSecondary))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 24)
                }
                TextFieldView(
                    text: $state.newPassword,
                    placeholder: Localizable.resetPasswordNewPasswordFieldPlaceholder(),
                    contentType: .password,
                    isSecured: true,
                    error: $state.newPasswordError
                )
                .padding(.bottom, 12)
                .focused($focusedField, equals: .newPassword)
                .onSubmit {
                    focusedField = .confirmPassword
                }
                TextFieldView(
                    text: $state.confirmPassword,
                    placeholder: Localizable.resetPasswordConfirmPasswordFieldPlaceholder(),
                    contentType: .password,
                    isSecured: true,
                    error: $state.confirmPasswordError
                )
                .padding(.bottom, 12)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    guard state.isReady else { return }
                    
                    state.tryResetPassword()
                }
                MainActionButton(Localizable.resetPasswordResetButtonTitle(), isDisabled: !state.isReady) {
                    focusedField = nil
                    state.tryResetPassword()
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .animation(.customTransition, value: focusedField)
        .activityIndicator(isShown: $state.showProgress)
        .onReceive(state.$newPassword) { _ in
            state.checkPassword()
            state.checkConfirmPassword()
        }
        .onReceive(state.$confirmPassword) { _ in
            state.checkConfirmPassword()
        }
        .onAppear {
            state.fetchEmail()
        }
    }
    
    // MARK: - Subviews
    
    var navigationView: some View {
        ZStack {
            HStack{
                Spacer()
                if focusedField != nil || state.showExpiredView {
                    TitleView(text: Localizable.resetPasswordTitle())
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
    
    var expiredView: some View {
        VStack {
            Text(Localizable.resetPasswordExpiredViewTitle())
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            Text(Localizable.resetPasswordExpiredViewMessage())
                .font(.system(size: 17))
                .foregroundStyle(Color(.textSecondary))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Constants

private enum Constants {
    
    static let navigationTitleEffectId = "titleResetPassword"
}
