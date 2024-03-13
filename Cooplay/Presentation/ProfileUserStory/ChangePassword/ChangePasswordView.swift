//
//  ChangePasswordView.swift
//  Cooplay
//
//  Created by Alexandr on 11.03.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ChangePasswordView: View {
    
    enum FocusedField {
        case currentPassword
        case newPassword
        case confirmPassword
    }
    
    @EnvironmentObject var state: ChangePasswordState
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: ProfileCoordinator
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextFieldView(
                text: $state.currentPassword,
                placeholder: Localizable.changePasswordCurrentPasswordPlaceholder(),
                contentType: .password,
                isSecured: true,
                error: $state.currentPasswordError
            )
            .padding(.bottom, 12)
            .padding(.top, 12)
            .focused($focusedField, equals: .currentPassword)
            .onSubmit {
                focusedField = .newPassword
            }
            TextFieldView(
                text: $state.newPassword,
                placeholder: Localizable.changePasswordNewPasswordPlaceholder(),
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
                placeholder: Localizable.changePasswordConfirmPasswordPlaceholder(),
                contentType: .password,
                isSecured: true,
                error: $state.confirmPasswordError
            )
            .padding(.bottom, 24)
            .focused($focusedField, equals: .confirmPassword)
            .onSubmit {
                focusedField = nil
                guard state.isReady else { return }
                
                state.tryChangePassword()
            }
            MainActionButton(Localizable.changePasswordActionButtonTitle(), isDisabled: !state.isReady) {
                focusedField = nil
                state.tryChangePassword()
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .animation(.customTransition, value: focusedField)
        .activityIndicator(isShown: $state.showProgress)
        .onReceive(state.$newPassword) { _ in
            state.checkNewPassword()
            state.checkConfirmPassword()
        }
        .onReceive(state.$confirmPassword) { _ in
            state.checkConfirmPassword()
        }
    }
    
}
