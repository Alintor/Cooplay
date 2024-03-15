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
    @EnvironmentObject var coordinator: HomeCoordinator
    @EnvironmentObject var namespace: NamespaceWrapper
    @State var isStatusButtonDisable = false
    let event: Event
    
    var body: some View {
        ZStack {
            Color(.block)
            VStack(spacing: 2) {
                EventItemView(event: event)
                statusView
                    .opacity(coordinator.editStatusEventId == event.id ? 0 : 1)
                    .onTapGesture {
                        isStatusButtonDisable = true
                        coordinator.show(.editStatus(event: event))
                    }
                    .disabled(isStatusButtonDisable)
            }
            .padding(4)
        }
        .clipShape(.rect(cornerRadius: 24, style: .continuous))
        .onReceive(coordinator.$editStatusEventId) { _ in
            guard isStatusButtonDisable else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isStatusButtonDisable = false
            }
        }
    }
    
    var statusView: some View {
        EventStatusView(
            viewModel: .init(with: state.acceptedEvents.first(where: { $0.id == event.id}) ?? event),
            isTapped: .constant(false)
        )
        .background(Color(.shapeBackground))
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .matchedGeometryEffect(id: MatchedAnimations.eventStatus(event.id).name, in: namespace.id)
        .animation(.customTransition, value: coordinator.editStatusEventId)
        .animation(.fastTransition, value: state.acceptedEvents.first(where: { $0.id == event.id})?.me.status)
    }
    
}

#Preview {
    AcceptedEventView(event: Event.mock)
}
