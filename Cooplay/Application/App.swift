//
//  App.swift
//  Cooplay
//
//  Created by Alexandr on 20.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

@main
struct RuwusApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if state.isAuthenticated {
                    ScreenViewFactory.home()
                        .zIndex(1)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                } else {
                    Color(.background)
                        .edgesIgnoringSafeArea(.all)
                    IntroView()
                        .zIndex(1)
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .animation(.customTransition, value: state.isAuthenticated)
            .onOpenURL { url in
                state.handleDeepLink(url)
            }
        }
    }
}
