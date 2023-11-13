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
    
    @State var contextPresented = false
    @Binding var showStatusContext: Bool
    @Binding var statusRect: CGRect
    var content: () -> Content
    var bottomSpacerHeight: CGFloat {
        state.eventsListSize.height - statusRect.origin.y - statusRect.size.height
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
                .onTapGesture {
                    contextPresented.toggle()
                }
            VStack {
                Spacer()
                content()
                    .padding(.bottom, contextPresented ? 8 : 0)
                    .onTapGesture {
                        contextPresented.toggle()
                    }
                    .transition(.scale)
                    .animation(.customTransition, value: showStatusContext)
                if !contextPresented {
                    Spacer()
                        .frame(height: bottomSpacerHeight)
                }
            }
            .padding(.horizontal, 8)
        }
        .animation(.customTransition, value: contextPresented)
        .onAppear {
            contextPresented = true
        }
        .onChange(of: contextPresented, perform: { value in
            guard !value else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showStatusContext = false
                Haptic.play(style: .medium)
            }
        })
    }
}
