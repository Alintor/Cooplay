//
//  AcceptedEventView.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AcceptedEventView: View {
    
    @EnvironmentObject var state: EventsListState
    let event: Event
    @State var showStatusContext = false
    @State var contextPresented = false
    @State var statusPosition: CGRect = .zero
    @Namespace var context
    
    var body: some View {
        ZStack {
            Color.r.block.color
            VStack(spacing: 2) {
                EventItemView(event: event)
                statusView
                    .handleRect(in: .named(GlobalConstant.CoordinateSpace.home)) { rect in
                        statusPosition = rect
                    }
                    .opacity(showStatusContext ? 0 : 1)
                    .onTapGesture {
                        showStatusContext.toggle()
                    }
            }
            .padding(4)
        }
        .frame(height: 170)
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .overlayModal(isPresented: $showStatusContext, content: {
            contextView
        })
        .animation(.customTransition, value: contextPresented)
        .onChange(of: showStatusContext, perform: { value in
            guard value else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                contextPresented = true
            }
        })
        .onChange(of: contextPresented, perform: { value in
            guard !value else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showStatusContext = false
            }
        })
    }
    
    var statusView: some View {
        EventStatusView(viewModel: .init(with: event), isTapped: $contextPresented)
            .background(Color.r.shapeBackground.color)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .animation(.customTransition, value: showStatusContext)
    }
    
    var contextView: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
            VStack {
                if contextPresented {
                    Spacer()
                } else {
                    Spacer()
                        .frame(height: statusPosition.origin.y)
                }
                statusView
                    .padding(.horizontal, 8)
                    .onTapGesture {
                        withAnimation(.customTransition) {
                            contextPresented.toggle()
                        }
                    }
                    .transition(.scale)
                    .animation(.customTransition, value: showStatusContext)
                if !contextPresented {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    AcceptedEventView(event: Event.mock)
}
