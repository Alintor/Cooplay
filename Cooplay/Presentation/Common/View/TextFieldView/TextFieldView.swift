//
//  TextFieldView.swift
//  Cooplay
//
//  Created by Alexandr on 17.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct TextFieldView: View {
    
    var text: Binding<String>
    let placeholder: String
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    let isSecured: Bool
    let showProgress: Binding<Bool>
    var error: Binding<String?>
    @FocusState var focused: Bool?
    @State var showSecured: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil,
        isSecured: Bool = false,
        showProgress: Binding<Bool> = .constant(false),
        error: Binding<String?> = .constant(nil)
    ) {
        self.text = text
        self.placeholder = placeholder
        self.error = error
        self.keyboardType = keyboardType
        self.contentType = contentType
        self.isSecured = isSecured
        self.showSecured = isSecured
        self.showProgress = showProgress
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            Group {
                if showSecured {
                    SecureField(placeholder, text: text)
                } else {
                    TextField(placeholder, text: text)
                }
            }
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: isSecured ? 48 : 14))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        error.wrappedValue == nil
                        ? (focused == true ? Color(R.color.actionAccent.name) : Color(R.color.block.name))
                        : Color(R.color.red.name),
                        lineWidth: 2
                    )
            )
            .background(Color(R.color.input.name))
            .clipShape(.rect(cornerRadius: 12, style: .continuous))
            .focused($focused, equals: true)
            .onChange(of: text.wrappedValue) { _ in
                withAnimation(.easeIn(duration: 0.2)) {
                    error.wrappedValue = nil
                }
            }
            .overlay(alignment: .trailing) {
                ZStack {
                    if showProgress.wrappedValue {
                        ProgressView()
                    }
                    if isSecured && !text.wrappedValue.isEmpty {
                        Image(showSecured ? .commonShow : .commonHide)
                            .foregroundStyle(Color(.textSecondary))
                            .onTapGesture {
                                showSecured.toggle()
                            }
                    }
                }
                .padding()
            }
            HStack {
                Text(error.wrappedValue ?? "")
                    .fontWeight(.medium)
                    .font(.system(size: 13))
                    .foregroundColor(Color(R.color.red.name))
                    .padding(.horizontal, 8)
                    .lineLimit(1, reservesSpace: true)
                Spacer()
            }
            .transition(.opacity.animation(.easeIn(duration: 0.2)))
        }
    }
}
