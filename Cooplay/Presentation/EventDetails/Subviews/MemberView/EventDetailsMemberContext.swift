//
//  EventDetailsMemberContext.swift
//  Cooplay
//
//  Created by Alexandr on 19.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsMemberContext: View {
    
    @EnvironmentObject var state: EventDetailsState
    @State var contextPresented = false
    @State var status: User.Status? = nil
    let viewModel: EventDetailsMemberViewModel
    @Binding var showStatusContext: Bool
    @Binding var targetRect: CGRect
    var bottomSpacerHeight: CGFloat {
        state.eventDetailsSize.height - targetRect.origin.y - targetRect.size.height
    }
    var showInBottom: Bool {
        let eventsDetailsCenter = state.eventDetailsSize.height / 2
        let targetPositionCenter = targetRect.origin.y + (targetRect.size.height / 2)
        return targetPositionCenter < eventsDetailsCenter
    }
    
    func close() {
        contextPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showStatusContext = false
            Haptic.play(style: .medium)
        }
    }
    
    // MARK: - Body
    
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
                        .frame(height: targetRect.origin.y + 72)
                } else {
                    Spacer()
                    contextView
                        .scaleEffect(contextPresented ? 1 : 0, anchor: .bottom)
                        .opacity(contextPresented ? 1 : 0)
                        .padding(.bottom, 4)
                }
                EventDetailsMemberInfoView(viewModel: viewModel)
                    .onTapGesture {
                        close()
                    }
                if showInBottom {
                    contextView
                        .scaleEffect(contextPresented ? 1 : 0, anchor: .top)
                        .opacity(contextPresented ? 1 : 0)
                        .padding(.top, 4)
                    Spacer()
                } else {
                    Spacer()
                        .frame(height: bottomSpacerHeight)
                }
            }
            .padding(.horizontal, 16)
        }
        .animation(.fastTransition, value: contextPresented)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
    }
    
    var contextView: some View {
        MemberContextView { action in
            close()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                state.handleMemberAction(action, member: viewModel.member)
            }
        }
    }
    
}
