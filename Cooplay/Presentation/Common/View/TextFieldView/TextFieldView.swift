//
//  TextFieldView.swift
//  Cooplay
//
//  Created by Alexandr on 17.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

enum PasswordValidation: Identifiable {
    
    case minLength(isValid: Bool?)
    case capitalLetter(isValid: Bool?)
    case digit(isValid: Bool?)
    
    var isValid: Bool? {
        switch self {
        case .minLength(let isValid): return isValid
        case .capitalLetter(let isValid): return isValid
        case .digit(let isValid): return isValid
        }
    }
    
    var title: String {
        switch self {
        case .minLength:
            Localizable.registrationPasswordSymbolsCountLabelTitle(GlobalConstant.Format.passwordMinLength)
        case .capitalLetter:
            Localizable.registrationPasswordBigSymbolLabelTitle()
        case .digit:
            Localizable.registrationPasswordNumericSymbolsLabelTitle()
        }
    }
    
    var id: Int {
        switch self {
        case .minLength: return 1
        case .capitalLetter: return 2
        case .digit: return 3
        }
    }
    
}

struct TextFieldView: View {
    
    enum ErrorType {
        
        case text(message: String?)
        case passwordValidation(types: [PasswordValidation])
        
        var isValid: Bool {
            switch self {
            case .text(let message):
                return message == nil
            case .passwordValidation(let types):
                return !types.contains(where: { $0.isValid == false })
            }
        }
    }
    
    var text: Binding<String>
    let placeholder: String
    let keyboardType: UIKeyboardType
    let contentType: UITextContentType?
    let isSecured: Bool
    let showProgress: Binding<Bool>
    var error: Binding<ErrorType?>
    @FocusState var focused: Bool?
    @State var showSecured: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: UIKeyboardType = .default,
        contentType: UITextContentType? = nil,
        isSecured: Bool = false,
        showProgress: Binding<Bool> = .constant(false),
        error: Binding<ErrorType?> = .constant(nil)
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
                        focused == true
                        ? Color(.actionAccent)
                        : error.wrappedValue?.borderColor ?? Color(.block),
                        lineWidth: 2
                    )
            )
            .background(Color(R.color.input.name))
            .clipShape(.rect(cornerRadius: 12, style: .continuous))
            .focused($focused, equals: true)
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
            switch error.wrappedValue {
            case .text(let message):
                textError(message: message)
                    .transition(.opacity.animation(.easeIn(duration: 0.2)))
            case .passwordValidation(let types):
                passwordValidation(types: types)
                    .transition(.opacity.animation(.easeIn(duration: 0.2)))
            case .none:
                textError(message: nil)
            }
        }
    }
    
    func textError(message: String?) -> some View {
        HStack {
            Text(message ?? "")
                .fontWeight(.medium)
                .font(.system(size: 13))
                .foregroundColor(Color(R.color.red.name))
                .padding(.horizontal, 8)
                .lineLimit(1, reservesSpace: true)
            Spacer()
        }
    }
    
    func passwordValidation(types: [PasswordValidation]) -> some View {
        HStack(spacing: 4) {
            ForEach(types) { type in
                validationItemView(type: type)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    func validationItemView(type: PasswordValidation) -> some View {
        HStack(spacing: 4) {
            if let icon = type.icon {
                icon
                    .foregroundStyle(type.textColor)
                    .frame(width: 12, height: 12)
            }
            Text(type.title)
                .font(.system(size: 12))
                .foregroundStyle(type.textColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(content: {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(type.backgroundColor)
        })
    }
}

private extension PasswordValidation {
    
    var textColor: Color {
        if let isValid {
            isValid ? Color(.green) : Color(.red)
        } else {
            Color(.textSecondary)
        }
    }
    
    var backgroundColor: Color {
        textColor.opacity(0.1)
    }
    
    var icon: Image? {
        guard let isValid else { return nil }
        
        return isValid
            ? Image(.statusSmallAccepted)
            : Image(.statusSmallDeclined)
    }
}

private extension TextFieldView.ErrorType {
    
    var borderColor: Color {
        switch self {
        case .text:
            return isValid ? Color(.green) : Color(.red)
        case .passwordValidation(let types):
            if types.contains(where: { $0.isValid == false }) {
                return Color(.red)
            }
            if types.contains(where: { $0.isValid == nil }) {
                return Color(.block)
            }
            return Color(.green)
        }
    }
    
}
