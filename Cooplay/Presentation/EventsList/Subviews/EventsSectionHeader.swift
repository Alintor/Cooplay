//
//  SwiftUIView.swift
//  Cooplay
//
//  Created by Alexandr on 13.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventsSectionHeader: View {
    
    let title: String
    
    var body: some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color(.textSecondary))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.top, 16)
            .transition(.move(edge: .leading))
    }
}
