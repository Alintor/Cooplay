//
//  InvitesIconView.swift
//  Cooplay
//
//  Created by Alexandr on 11.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NotificationAnimation: View {
    
    @State private var bellRotating = 30
    
    var body: some View {
        ZStack {
            Image(systemName: "bell.fill") // Body
                .shadow(radius: 4 )
                .rotationEffect(.degrees( Double(bellRotating)), anchor: .top)
                //.hueRotation(.degrees(200))
                .animation(.interpolatingSpring(stiffness: 170, damping: 5).repeatForever(autoreverses: false), value: bellRotating)
        }
        .onAppear() {
            bellRotating = 0
        }
        
    }
}

struct NotificationAnimation_Previews: PreviewProvider {
    static var previews: some View {
        NotificationAnimation()
            .preferredColorScheme(.dark)
            .frame(width: 32, height: 32)
    }
}
