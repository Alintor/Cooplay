//
//  EventsListView.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventsListView: View {
    
    @EnvironmentObject var state: EventsListState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        ZStack {
            events
            VStack {
                Spacer()
                newEventButton
            }
        }
        .padding(.horizontal, 4)
        .coordinateSpace(name: GlobalConstant.CoordinateSpace.eventsList)
        .handleRect(in: .global) {
            if state.eventsListSize != $0.size {
                state.eventsListSize = $0.size
            }
        }
        .animation(.customTransition, value: state.invitedEvents)
        .animation(.customTransition, value: state.acceptedEvents)
        .animation(.customTransition, value: state.declinedEvents)
    }
    
    // MARK: - Subviews
    
    var events: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                if state.invitedEvents.count > 0 {
                    EventsSectionHeader(title: Localizable.eventsListSectionsInvited())
                    ForEach(state.invitedEvents, id:\.inviteId) { item in
                        InvitedEventView(event: item)
                            .zIndex(1)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }
                }
                if state.acceptedEvents.count > 0 {
                    EventsSectionHeader(title: Localizable.eventsListSectionsFuture())
                    ForEach(state.acceptedEvents, id:\.id) { item in
                        AcceptedEventView(event: item)
                            .zIndex(1)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }
                }
                if state.declinedEvents.count > 0 {
                    DeclinedEventsView()
                }
            }
            .padding(.bottom, 72)
            .padding(.top, 64)
        }
    }
    
    var newEventButton: some View {
        Button(action: {
            state.openNewEvent()
        }, label: {
            Label(Localizable.newEventMainActionTitle(), systemImage: "plus")
                .font(.system(size: 20))
                .foregroundStyle(Color(.textPrimary))
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
        })
        .background(Color(.actionAccent))
        .clipShape(.rect(cornerRadius: 48, style: .continuous))
        .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
        .padding(.bottom, 8)
        .background {
            TransparentBlurView(removeAllFilters: false)
                .blur(radius: 15)
                .padding([.horizontal, .bottom], -30)
                .frame(width: UIScreen.main.bounds.size.width)
                .ignoresSafeArea()
        }
    }

}


extension Event {
    
    var inviteId: String {
        return "\(self.id)_invite"
    }
    
    var declineId: String {
        return "\(self.id)_decline"
    }
}
