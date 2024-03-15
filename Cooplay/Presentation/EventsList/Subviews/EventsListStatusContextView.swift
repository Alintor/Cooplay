//
//  EventsListStatusContextView.swift
//  Cooplay
//
//  Created by Alexandr on 12.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventsListStatusContextView: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: HomeCoordinator
    @State var status: User.Status? = nil
    @State var showChangeStatusContext = false
    @State var isButtonDisable = true
    let event: Event
    
    func close() {
        isButtonDisable = true
        showChangeStatusContext = false
        coordinator.hideFullScreenCover()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if let status = status {
                coordinator.changeStatus(status, for: event)
            }
            Haptic.play(style: .medium)
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .dark), intensity: 0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    close()
                }
            VStack(spacing: 0) {
                Spacer()
                StatusContextView(event: event) { status in
                    close()
                    self.status = status
                }
                .background(Color(.shapeBackground))
                .clipShape(.rect(cornerRadius: 16, style: .continuous))
                .scaleEffect(showChangeStatusContext ? 1 : 0, anchor: .bottom)
                .opacity(showChangeStatusContext ? 1 : 0)
                .padding(.bottom, 4)
                EventStatusView(viewModel: .init(with: event), isTapped: .constant(true))
                    .background(Color(.shapeBackground))
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
                    .matchedGeometryEffect(id: MatchedAnimations.eventStatus(event.id).name, in: namespace.id)
                    .padding(.bottom, 8)
                    .onTapGesture {
                        close()
                    }
                    .disabled(isButtonDisable)
            }
            .padding(.horizontal, 8)
        }
        .animation(.fastTransition, value: showChangeStatusContext)
        .animation(.fastTransition, value: event.me.status)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isButtonDisable = false
                showChangeStatusContext.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Haptic.play(style: .medium)
            }
        }
    }
    
}
