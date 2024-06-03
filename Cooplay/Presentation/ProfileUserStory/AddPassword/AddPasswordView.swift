//
//  AddPasswordView.swift
//  Cooplay
//
//  Created by Alexandr on 28.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AddPasswordView: View {
    
    enum FocusedField {
        case email
        case newPassword
        case confirmPassword
    }
    
    @StateObject var state: AddPasswordState
    @EnvironmentObject var coordinator: ProfileCoordinator
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            ProfileNavigationView(title: Localizable.addPasswordTitle(), isBackButton: .constant(true)) {
                coordinator.open(.account(isBack: true))
            }
            VStack {
                TextFieldView(
                    text: $state.email,
                    placeholder: Localizable.addPasswordEmailPlaceholder(),
                    keyboardType: .emailAddress,
                    contentType: .emailAddress,
                    error: .constant(nil)
                )
                .padding(.bottom, 4)
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .newPassword
                }
                TextFieldView(
                    text: $state.newPassword,
                    placeholder: Localizable.addPasswordNewPasswordFieldPlaceholder(),
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
                    placeholder: Localizable.addPasswordConfirmPasswordFieldPlaceholder(),
                    contentType: .password,
                    isSecured: true,
                    error: $state.confirmPasswordError
                )
                .padding(.bottom, 12)
                .focused($focusedField, equals: .confirmPassword)
                .onSubmit {
                    focusedField = nil
                    guard state.isReady else { return }
                    
                    state.tryAddPassword()
                }
                MainActionButton(Localizable.addPasswordTitle(), isDisabled: !state.isReady) {
                    focusedField = nil
                    state.tryAddPassword()
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .animation(.customTransition, value: focusedField)
        .activityIndicator(isShown: $state.showProgress)
        .alert(Localizable.addPasswordAlertGoogle(), isPresented: $state.showGoogleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.addPasswordAlertButton(), role: .none) {
                state.tryAddPassword()
            }
        })
        .alert(Localizable.addPasswordAlertApple(), isPresented: $state.showAppleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.addPasswordAlertButton(), role: .none) {
                state.tryAddPassword()
            }
        })
        .onReceive(state.$newPassword) { _ in
            state.checkPassword()
            state.checkConfirmPassword()
        }
        .onReceive(state.$confirmPassword) { _ in
            state.checkConfirmPassword()
        }
        .onAppear {
            state.close = {
                coordinator.open(.account(isBack: true))
            }
        }
    }
    
}
