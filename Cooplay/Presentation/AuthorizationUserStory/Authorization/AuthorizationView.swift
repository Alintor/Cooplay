//
//  AuthorizationView.swift
//  Cooplay
//
//  Created by Alexandr on 30.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AuthorizationView: View {
    
    @EnvironmentObject var coordinator: AuthorizationCoordinator
    @Namespace var namespace
    
    var body: some View {
        ZStack {
            Color(.background)
                .edgesIgnoringSafeArea(.all)
            coordinator.buildView()
                .environmentObject(NamespaceWrapper(namespace))
        }
        .animation(.customTransition, value: coordinator.route)
    }
}
