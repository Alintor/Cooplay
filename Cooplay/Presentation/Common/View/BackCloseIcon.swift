//
//  BackCloseButton.swift
//  Cooplay
//
//  Created by Alexandr on 05.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct BackCloseIcon: View {
    
    @Binding var isBack: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 10, height: 2)
                .cornerRadius(2)
                .rotationEffect(.degrees(-45), anchor: .leading)
                .padding(.top, isBack ? 0 : 1.5)
                .padding(.leading, isBack ? -6 : 8)
            Rectangle()
                .frame(width: 18, height: 2)
                .cornerRadius(2)
                .rotationEffect(.degrees(isBack ? 0 : 45), anchor: .center)
            Rectangle()
                .frame(width: 10, height: 2)
                .cornerRadius(2)
                .rotationEffect(.degrees(isBack ? 45: 135), anchor: .trailing)
                .padding(.top, isBack ? 14 : 12)
                .padding(.leading, isBack ? -11.5 : -16)
        }
        .contentShape(Rectangle())
        .animation(.default, value: isBack)
    }
}

struct BackCloseIcon_Previews: PreviewProvider {
    static var previews: some View {
        BackCloseIcon(isBack: .constant(true))
    }
}
