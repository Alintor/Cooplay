//
//  MainActionButton.swift
//  Cooplay
//
//  Created by Alexandr on 17.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct MainActionButton: View {
    
    let title: String
    let action: () -> Void
    var isDisabled: Bool
    
    init(_ title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.isDisabled = isDisabled
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(Color(R.color.textPrimary.name))
                .font(.system(size: 20))
                .frame(maxWidth: .infinity)
                .padding(16)
        }
        .background(Color(R.color.actionAccent.name))
        .cornerRadius(16)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}
