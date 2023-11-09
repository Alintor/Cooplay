//
//  ActivityIndicatorModifier.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorModifier: ViewModifier {
    
    @Binding var isShown: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isShown ? 80 : 0)
            if isShown {
                ActivityIndicatorView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.customTransition, value: isShown)
    }
}

extension View {
    func activityIndicator(isShown: Binding<Bool>) -> some View {
        self.modifier(ActivityIndicatorModifier(isShown: isShown))
    }
}
