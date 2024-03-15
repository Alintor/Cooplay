//
//  HomeLoadingIndicator.swift
//  Cooplay
//
//  Created by Alexandr on 26.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeLoadingIndicator: View {
    
    @State var isBounce: Bool = false
    @State var isFirstColor: Bool = true
    
    var firstColor: Color {
        Color(uiColor: UIColor.avatarColors[Int.random(in: 0..<4)])
    }
    var secondColor: Color {
        Color(uiColor: UIColor.avatarColors[Int.random(in: 4..<8)])
    }
    
    var body: some View {
        ZStack {
            circle
        }
        .padding(.top, -210)
        
    }
    
    var circle: some View {
        HStack {
            if isBounce {
                Spacer()
            }
            Capsule().fill(isFirstColor ? firstColor : secondColor)
                .frame(width: 300, height: 240, alignment: .center)
                .opacity(0.15)
            .blur(radius: 25)
            if !isBounce {
                Spacer()
            }
        }
        .padding(.horizontal, -330)
        .animation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: false),
            value: isBounce
        )
        .animation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: false),
            value: isFirstColor
        )
        .onAppear() {
            isBounce.toggle()
            isFirstColor.toggle()
        }
    }
        
}

#Preview {
    HomeLoadingIndicator()
}
