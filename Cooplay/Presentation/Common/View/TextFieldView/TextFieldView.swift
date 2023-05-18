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
    var error: Binding<String?>?
    @FocusState var focused: Bool?
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        error: Binding<String?>? = nil
    ) {
        self.text = text
        self.placeholder = placeholder
        self.error = error
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            TextField(placeholder, text: text)
                .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            error?.wrappedValue == nil
                            ? (focused == true ? Color(R.color.actionAccent.name) : Color(R.color.block.name))
                            : Color(R.color.red.name),
                            lineWidth: 2
                        )
                )
                .background(Color(R.color.input.name))
                .cornerRadius(12)
                .focused($focused, equals: true)
                .onChange(of: text.wrappedValue) { _ in
                    withAnimation(.easeIn(duration: 0.2)) {
                        error?.wrappedValue = nil
                    }
                }
            HStack {
                if let error = error?.wrappedValue {
                    Text(error)
                        .fontWeight(.medium)
                        .font(.system(size: 13))
                        .foregroundColor(Color(R.color.red.name))
                        .padding(.horizontal, 8)
                    Spacer()
                }
            }
            .transition(.opacity.animation(.easeIn(duration: 0.2)))
        }
    }
}
