//
//  AuthorizationMenuView.swift
//  Cooplay
//
//  Created by Alexandr on 30.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AuthorizationMenuView: View {
    
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack {
            Image(.commonLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.top, 80)
            Spacer()
            MainActionButton(Localizable.authorizationMenuLogin()) {
                coordinator.openLogin()
            }
            .matchedGeometryEffect(id: MatchedAnimations.loginButton.name, in: namespace.id)
            .padding(.bottom, 16)
            Button {
                coordinator.openRegister()
            } label: {
                Text(Localizable.authorizationMenuRegister())
                    .foregroundColor(Color(.actionAccent))
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity)
                    .padding(16)
            }
            .background(Color(.block))
            .clipShape(.rect(cornerRadius: 16, style: .continuous))
            .matchedGeometryEffect(id: MatchedAnimations.registerButton.name, in: namespace.id)
            .padding(.bottom, 80)
        }
        .padding(.horizontal, 24)
    }
}
