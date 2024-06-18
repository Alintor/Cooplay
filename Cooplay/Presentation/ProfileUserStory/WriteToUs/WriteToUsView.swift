//
//  WriteUsView.swift
//  Cooplay
//
//  Created by Alexandr on 17.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct WriteToUsView: View {
    
    enum FocusedField {
        case message
    }
    
    @StateObject var state: WriteToUsState
    @EnvironmentObject var coordinator: ProfileCoordinator
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            Text(Localizable.writeToUsMessage())
                .font(.system(size: 15))
                .foregroundStyle(Color(.textSecondary))
                .padding(.bottom, 12)
            textEditor
                .scrollDisabled(state.feedbackText.isEmpty)
                .frame(height: 128)
                .background(Color(.input))
                .foregroundStyle(Color(.textPrimary))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(
                            focusedField == .message
                            ? Color(.actionAccent)
                            : Color(.block),
                            lineWidth: 2
                        )
                )
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .focused($focusedField, equals: .message)
                .overlay(alignment: .topLeading) {
                    if state.feedbackText.isEmpty {
                        Text(Localizable.writeToUsPlaceholder())
                            .foregroundStyle(Color(.textSecondary))
                            .padding(.top, 8)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.bottom, 16)
            MainActionButton(Localizable.writeToUsActionButton(), isDisabled: !state.isReady) {
                focusedField = nil
                state.trySendFeedback()
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .activityIndicator(isShown: $state.showProgress)
        .onAppear {
            state.close = {
                coordinator.open(.menu)
            }
        }
    }
    
    @ViewBuilder var textEditor: some View {
        if #available(iOS 17.0, *) {
            TextEditor(text: $state.feedbackText)
                .contentMargins(.horizontal, 8)
        } else {
            TextEditor(text: $state.feedbackText)
        }
    }
    
}
