//
//  SearchField.swift
//  Cooplay
//
//  Created by Alexandr on 11.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchField: View {
    
    var text: Binding<String>
    let placeholder: String
    
    init(
        text: Binding<String>,
        placeholder: String = ""
    ) {
        self.text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        TextField(placeholder, text: text)
            .frame(height: 36)
            .padding(.horizontal, 34)
            .background(Color(.background))
            .clipShape(.rect(cornerRadius: 8, style: .continuous))
            .overlay(alignment: .leading) {
                Image(.commonSearch)
                    .foregroundStyle(Color(.textSecondary))
                    .opacity(0.5)
                    .frame(width: 16, height: 16)
                    .padding(.leading, 10)
            }
            .overlay(alignment: .trailing) {
                if !text.wrappedValue.isEmpty {
                    Image(.commonCloseCircle)
                        .resizable()
                        .foregroundStyle(Color(.textSecondary))
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 10)
                        .transition(.scale.combined(with: .opacity))
                        .onTapGesture {
                            text.wrappedValue = ""
                        }
                }
            }
            .animation(.customTransition, value: text.wrappedValue)
    }
}
