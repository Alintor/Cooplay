//
//  InvitesIconView.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct InvitesIconView: View {
    
    @State private var bellRotating = 15
    let count: Int
    
    var body: some View {
        ZStack {
            Image(systemName: "bell.fill")
                .foregroundStyle(Color(.textPrimary))
                .scaleEffect(1.5)
                .rotationEffect(.degrees( Double(bellRotating)), anchor: .top)
                .animation(
                    .interpolatingSpring(mass: 0.5, stiffness: 100, damping: 2)
                    .repeatForever(autoreverses: false),
                    value: bellRotating
                )
            Text("\(count)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(.textPrimary))
                .padding(.horizontal, 5)
                .padding(.vertical, 1)
                .background(Color(.red))
                .clipShape(.capsule)
                .padding(.bottom, 10)
                .padding(.leading, 10)
        }
        .onAppear() {
            bellRotating = 0
        }
        
    }
}

#Preview {
    InvitesIconView(count: 1)
        .frame(width: 32, height: 32)
}
