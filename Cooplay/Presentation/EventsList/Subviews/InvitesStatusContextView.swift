//
//  InvitesStatusContextView.swift
//  Cooplay
//
//  Created by Alexandr on 13.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct InvitesStatusContextView<Content: View>: View {
    
    @EnvironmentObject var state: EventsListState
    @State var contextPresented = false
    @State var status: User.Status? = nil
    let event: Event
    @Binding var showStatusContext: Bool
    @Binding var targetRect: CGRect
    var content: () -> Content
    var bottomSpacerHeight: CGFloat {
        state.eventsListSize.height - targetRect.origin.y - targetRect.size.height
    }
    var showInBottom: Bool {
        let eventsListCenter = state.eventsListSize.height / 2
        let targetPositionCenter = targetRect.origin.y + (targetRect.size.height / 2)
        return targetPositionCenter < eventsListCenter
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
                .onTapGesture {
                    close()
                }
            VStack(spacing: 0) {
                if showInBottom {
                    Spacer()
                        .frame(height: targetRect.origin.y)
                } else {
                    Spacer()
                    contextView
                        .scaleEffect(contextPresented ? 1 : 0, anchor: .bottomTrailing)
                        .opacity(contextPresented ? 1 : 0)
                        .padding(.bottom, 4)
                }
                HStack {
                    Spacer()
                    content()
                        .frame(width: targetRect.size.width)
                        .onTapGesture {
                            close()
                        }
                }
                if showInBottom {
                    contextView
                        .scaleEffect(contextPresented ? 1 : 0, anchor: .topTrailing)
                        .opacity(contextPresented ? 1 : 0)
                        .padding(.top, 4)
                    Spacer()
                } else {
                    Spacer()
                        .frame(height: bottomSpacerHeight)
                }
            }
            .padding(.horizontal, 8)
        }
        .animation(.customTransition, value: contextPresented)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
        .onChange(of: contextPresented, perform: { value in
            guard !value else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showStatusContext = false
                if let status = status {
                    state.changeStatus(status, for: event)
                }
                Haptic.play(style: .medium)
            }
        })
    }
    
    var contextView: some View {
        StatusContextView(event: event) { status in
            close()
            self.status = status
        }
    }
    
    func close() {
        contextPresented.toggle()
    }
}
