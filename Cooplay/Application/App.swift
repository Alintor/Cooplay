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
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                } else {
                    ScreenViewFactory.authorization()
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
                VStack {
                    if let notificationBanner = state.notificationBanner {
                        notificationBannerView(notificationBanner)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onTapGesture {
                                state.hideNotificationBanner()
                            }
                    }
                    Spacer()
                }
            }
            .animation(.customTransition, value: state.isAuthenticated)
            .animation(.customTransition, value: state.notificationBanner)
            .onOpenURL { url in
                state.handleDeepLink(url)
            }
        }
    }
    
    func notificationBannerView(_ notificationBanner: NotificationBanner) -> some View {
        HStack(spacing: 12) {
            notificationBanner.icon
                .frame(width: 24, height: 24, alignment: .center)
                .foregroundStyle(notificationBanner.iconColor)
            VStack(spacing: 0) {
                Text(notificationBanner.title)
                    .font(Font.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(.textPrimary))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if let message = notificationBanner.message {
                    Text(message)
                        .font(Font.system(size: 13, weight: .regular))
                        .foregroundStyle(Color(.textSecondary))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.shapeBackground))
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
}

private extension NotificationBanner {
    
    var icon: Image {
        switch self.type {
        case .networkError:
            Image(.commonLinkBroken)
        }
    }
    var iconColor: Color {
        switch self.type {
        case .networkError:
            Color(.red)
        }
    }
}
