//
//  EventsListStatusContextView.swift
//  Cooplay
//
//  Created by Alexandr on 12.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventsListStatusContextView<Content: View>: View {
    
    @EnvironmentObject var state: EventsListState
    @State var status: User.Status? = nil
    @State var contextPresented = false
    @State var showChangeStatusContext = false
    let event: Event
    @Binding var showStatusContext: Bool
    @Binding var statusRect: CGRect
    var content: () -> Content
    var bottomSpacerHeight: CGFloat {
        let bottom = state.eventsListSize.height - statusRect.origin.y - statusRect.size.height - 8
        if statusRect.origin.y < 236 {
            return bottom + (236 - statusRect.origin.y)
        } else {
            return bottom
        }
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
                Spacer()
                StatusContextView(event: event) { status in
                    close()
                    self.status = status
                }
                .scaleEffect(showChangeStatusContext ? 1 : 0, anchor: .bottom)
                .opacity(showChangeStatusContext ? 1 : 0)
                .padding(.bottom, 4)
                content()
                    .padding(.bottom, 8)
                    .onTapGesture {
                        close()
                    }
                if !contextPresented {
                    Spacer()
                        .frame(height: bottomSpacerHeight)
                }
            }
            .padding(.horizontal, 8)
        }
        .animation(.customTransition, value: contextPresented)
        .animation(.interpolatingSpring(stiffness: 300, damping: 28), value: showChangeStatusContext)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showChangeStatusContext.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Haptic.play(style: .medium)
            }
        }
        .onChange(of: contextPresented, perform: { value in
            guard !value else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                if let status = status {
                    state.changeStatus(status, for: event)
                }
                showStatusContext = false
                Haptic.play(style: .medium)
            }
        })
    }
    
    func close() {
        showChangeStatusContext.toggle()
        contextPresented.toggle()
    }
}
