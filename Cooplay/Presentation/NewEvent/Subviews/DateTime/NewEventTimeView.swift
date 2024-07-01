//
//  NewEventTimeView.swift
//  Cooplay
//
//  Created by Alexandr on 27.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventTimeView: View {
    
    let timeValue: String
    let isOpened: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Text(timeValue)
                .foregroundStyle(Color(.textPrimary))
                .font(.system(size: 20))
            Image(isOpened ? .commonArrowUp : .commonArrowDown)
                .foregroundStyle(Color(.textPrimary))
                .frame(width: 12, height: 12)
            Spacer()
            Image(.commonClock)
                .foregroundStyle(Color(.actionAccent))
                .frame(width: 24, height: 24)
            
        }
        .padding(16)
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
}
