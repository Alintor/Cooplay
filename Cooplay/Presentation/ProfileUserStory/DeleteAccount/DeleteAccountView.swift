//
//  DeleteAccountView.swift
//  Cooplay
//
//  Created by Alexandr on 29.05.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct DeleteAccountView: View {
    
    enum FocusedField {
        case password
    }
    
    @StateObject var state: DeleteAccountState
    @EnvironmentObject var coordinator: ProfileCoordinator
    @FocusState private var focusedField: FocusedField?
    @State var showPasswordAlert = false
    @State var showAppleAlert = false
    @State var showGoogleAlert = false
    
    var body: some View {
        VStack {
            ProfileNavigationView(title: Localizable.deleteAccountTitle(), isBackButton: .constant(true)) {
                coordinator.open(.account(isBack: true))
            }
            VStack {
                Text(Localizable.deleteAccountMessage())
                    .font(.system(size: 13))
                    .foregroundStyle(Color(.textSecondary))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 12)
                if state.showPassword {
                    TextFieldView(
                        text: $state.password,
                        placeholder: Localizable.deleteAccountPassword(),
                        contentType: .password,
                        isSecured: true,
                        error: $state.passwordError
                    )
                    .padding(.bottom, 12)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        focusedField = .password
                    }
                }
                Button(action: {
                    focusedField = nil
                    switch state.provider {
                    case .password: showPasswordAlert = true
                    case .google: showGoogleAlert = true
                    case .apple: showAppleAlert = true
                    case .none: break
                    }
                }, label: {
                    Text(Localizable.deleteAccountActionButton())
                        .foregroundColor(Color(R.color.textPrimary.name))
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding(16)
                })
                .background(state.isButtonActive ? Color(.red) : Color(.shapeBackground))
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .disabled(!state.isButtonActive)
                .opacity(state.isButtonActive ? 1 : 0.5)
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .animation(.customTransition, value: focusedField)
        .activityIndicator(isShown: $state.showProgress)
        .alert(Localizable.deleteAccountAlertTitle(), isPresented: $showPasswordAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.deleteAccountAlertButton(), role: .destructive) {
                state.tryDeleteAccount()
            }
        })
        .alert(Localizable.deleteAccountAlertTitle(), isPresented: $showAppleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.deleteAccountAlertButton(), role: .destructive) {
                state.tryDeleteAccount()
            }
        }, message: {
            Text(Localizable.deleteAccountAlertApple())
        })
        .alert(Localizable.deleteAccountAlertTitle(), isPresented: $showGoogleAlert, actions: {
            Button(Localizable.commonCancel(), role: .cancel) {}
            Button(Localizable.deleteAccountAlertButton(), role: .destructive) {
                state.tryDeleteAccount()
            }
        }, message: {
            Text(Localizable.deleteAccountAlertGoogle())
        })
    }
    
}
