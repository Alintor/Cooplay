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
    @EnvironmentObject var namespace: NamespaceWrapper
    let event: Event
    @State var showStatusContext = false
    @State var statusRect: CGRect = .zero
    @Namespace var context
    
    var body: some View {
        ZStack {
            Color(.block)
            VStack(spacing: 2) {
                EventItemView(event: event)
                statusView
                    .handleRect(in: .named(GlobalConstant.CoordinateSpace.eventsList)) { statusRect = $0 }
                    .opacity(showStatusContext ? 0 : 1)
                    .onTapGesture {
                        showStatusContext.toggle()
                    }
            }
            .padding(4)
        }
        .frame(height: 170)
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .overlayModal(isPresented: $showStatusContext, content: {
            EventsListStatusContextView(
                event: event, 
                showStatusContext: $showStatusContext,
                statusRect: $statusRect,
                content: { statusView}
            )
        })
    }
    
    var statusView: some View {
        EventStatusView(viewModel: .init(with: event), isTapped: $showStatusContext)
            .background(Color(.shapeBackground))
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .matchedGeometryEffect(id: MatchedAnimations.eventStatus(event.id).name, in: namespace.id)
            .animation(.customTransition, value: showStatusContext)
    }
    
}

#Preview {
    AcceptedEventView(event: Event.mock)
}
