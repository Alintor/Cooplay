//
//  AuthorizationCoordinator.swift
//  Cooplay
//
//  Created by Alexandr on 30.01.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

class AuthorizationCoordinator: ObservableObject {
    
    enum Route {
        
        case menu
        case login
        case register
    }
    
    @Published var route: Route
    
    // MARK: - Init
    
    init() {
        self.route = .menu
    }
    
    // MARK: - Methods
    
    @ViewBuilder func buildView() -> some View {
        switch route {
        case .menu:
            AuthorizationMenuView()
                //.zIndex(1)
                .transition(.move(edge: .leading))
        case .login:
            ScreenViewFactory.login()
                //.zIndex(1)
                .closable(anchor: .trailing) {
                    self.backToMenu()
                }
                .transition(.move(edge: .trailing))
        case .register:
            AuthorizationMenuView()
                .transition(.move(edge: .trailing))
        }
    }
    
    func openLogin() {
        route = .login
    }
    
    func openRegister() {
        route = .register
    }
    
    func backToMenu() {
        route = .menu
    }
    
}
