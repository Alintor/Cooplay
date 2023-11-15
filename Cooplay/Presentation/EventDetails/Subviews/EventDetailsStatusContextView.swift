//
//  EventDetailsStatusContextView.swift
//  Cooplay
//
//  Created by Alexandr on 15.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsStatusContextView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @State var contextPresented = false
    @Binding var showStatusContext: Bool
    
    func close() {
        contextPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showStatusContext = false
            Haptic.play(style: .medium)
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
                .onTapGesture { close() }
            VStack(spacing: 8) {
                Spacer()
                if contextPresented {
                    StatusContextView(event: state.event) { status in
                        state.changeStatus(status)
                        close()
                    }
                    .transition(.scale(scale: 0, anchor: .bottom).combined(with: .opacity))
                }
                EventStatusView(viewModel: .init(with: state.event), isTapped: $contextPresented)
                    .background(Color(R.color.block.name))
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .onTapGesture { close() }
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
        }
        .animation(.fastTransition, value: contextPresented)
        .animation(.fastTransition, value: state.event.me.status)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
    }
}
