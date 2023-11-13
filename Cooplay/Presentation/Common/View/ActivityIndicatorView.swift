//
//  ActivityIndicatorView.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: View {
    
    @State var isDefault: Bool = true
    @State var isRotate: Bool = false
    
    var body: some View {
        VStack(spacing: isDefault ? -1 : 4) {
            Image(.commonGamepadArrow)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 16)
                .foregroundStyle(Color(.textSecondary))
                .rotationEffect(.radians(.pi / 2))
            HStack(spacing: isDefault ? 4 : 16) {
                Image(.commonGamepadArrow)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 16)
                    .foregroundStyle(Color(.textSecondary))
                Image(.commonGamepadArrow)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 16)
                    .rotationEffect(.radians(.pi))
                    .foregroundStyle(Color(.textSecondary))
            }
            Image(.commonGamepadArrow)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 16)
                .rotationEffect(.radians(.pi / -2))
                .foregroundStyle(Color(.textSecondary))
        }
        .rotationEffect(.radians(isRotate ? .pi : 0))
        .onAppear {
            withAnimation(.interpolatingSpring(duration: 0.5, bounce: 1, initialVelocity: 1).repeatForever(autoreverses: true)) {
                isDefault.toggle()
            }
            withAnimation(.easeOut(duration: 0.5).delay(0.5).repeatForever(autoreverses: false)) {
                isRotate.toggle()
            }
        }
    }
}

#Preview {
    ActivityIndicatorView()
}
