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
    
    enum Route: Equatable {
        
        case menu
        case login(email: String)
        case register(email: String)
        case resetPassword(code: String)
    }
    
    @Published var route: Route
    
    // MARK: - Init
    
    init() {
        self.route = .menu
        NotificationCenter.default.addObserver(self, selector: #selector(resetPassword(_:)), name: .handleResetPassword, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    @ViewBuilder func buildView() -> some View {
        switch route {
        case .menu:
            AuthorizationMenuView()
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .opacity))
        case .login(let email):
            ScreenViewFactory.login(email: email)
                .closable(anchor: .trailing) {
                    self.backToMenu()
                }
                .transition(.move(edge: .trailing))
        case .register(let email):
            ScreenViewFactory.register(email: email)
                .closable(anchor: .trailing) {
                    self.backToMenu()
                }
                .transition(.move(edge: .trailing))
        case .resetPassword(let code):
            ScreenViewFactory.resetPassword(oobCode: code)
                .closable(anchor: .trailing) {
                    self.backToMenu()
                }
                .transition(.move(edge: .trailing))
        }
    }
    
    func openLogin(email: String = "") {
        route = .login(email: email)
    }
    
    func openRegister(email: String = "") {
        route = .register(email: email)
    }
    
    func backToMenu() {
        route = .menu
    }
    
    @objc private func resetPassword(_ notification: NSNotification) {
        guard 
            let userInfo = notification.userInfo as? [String: Any],
            let oobCode = userInfo["oobCode"] as? String
        else { return }
        
        route = .resetPassword(code: oobCode)
    }
    
}
