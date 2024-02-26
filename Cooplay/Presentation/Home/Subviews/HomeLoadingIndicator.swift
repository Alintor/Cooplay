//
//  HomeLoadingIndicator.swift
//  Cooplay
//
//  Created by Alexandr on 26.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct HomeLoadingIndicator: View {
    
    @State var isBounce: Bool = true
    @State var isColorMain: Bool = false
    
    var circleColor: Color {
        let colors = [Color(.yellow), Color(.green), Color(.red)]
        let firstIndex = Int.random(in: 0..<3)
        let secondIndex = Int.random(in: 0..<5)
        return isColorMain
            ? colors[firstIndex]
            : Color(uiColor: UIColor.avatarColors[secondIndex])
    }
    
    var body: some View {
        ZStack {
            circle
        }
        .padding(.top, -190)
        
    }
    
    var circle: some View {
        HStack {
            if isBounce {
                Spacer()
            }
            Capsule().fill(circleColor)
                .frame(width: 300, height: 240, alignment: .center)
                .opacity(0.35)
            .blur(radius: 25)
            if !isBounce {
                Spacer()
            }
        }
        .padding(.horizontal, -200)
        .animation(
            .easeInOut(duration: 1)
            .repeatForever(autoreverses: true),
            value: isBounce
        )
        .onAppear() {
            isBounce.toggle()
            isColorMain.toggle()
        }
    }
        
}

#Preview {
    HomeLoadingIndicator()
}
