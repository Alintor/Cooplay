//
//  EventChangeDateContextView.swift
//  Cooplay
//
//  Created by Alexandr on 18.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventChangeDateContextView<Content: View>: View {
    
    @EnvironmentObject var state: EventDetailsState
    @State var contextPresented = false
    @Binding var showDateContext: Bool
    @Binding var targetRect: CGRect
    var content: () -> Content
    
    func close() {
        contextPresented = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            showDateContext = false
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
                Spacer()
                    .frame(height: targetRect.origin.y)
                content()
                    .frame(width: targetRect.size.width)
                    .onTapGesture {
                        close()
                    }
                if contextPresented {
                    TimeCarouselPanelView(
                        configuration: .init(type: .change, date: state.event.date),
                        cancelHandler: { close() },
                        confirmHandler: nil,
                        dateHandler: { date in
                            state.changeDate(date)
                            close()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                state.changeEditMode()
                            }
                        })
                        .frame(height: 200)
                        .clipShape(.rect(cornerRadius: 16, style: .continuous))
                        .padding(.top, 4)
                        .padding(.horizontal, 8)
                        .transition(.scale(scale: 0, anchor: .top).combined(with: .opacity))
                    
                }
                Spacer()
            }
            .padding(.horizontal, 8)
        }
        .animation(.fastTransition, value: contextPresented)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
    }
    
}
