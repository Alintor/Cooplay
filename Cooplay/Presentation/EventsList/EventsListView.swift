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
            ScrollView {
                LazyVStack(spacing: 8) {
                    if state.invitedEvents.count > 0 {
                        sectionHeader(Localizable.eventsListSectionsInvited())
                        ForEach(state.invitedEvents, id:\.inviteId) { item in
                            InvitedEventView(event: item)
                                .transition(.scale(scale: 0.5).combined(with: .opacity))
                        }
                    }
                    if state.acceptedEvents.count > 0 {
                        sectionHeader(Localizable.eventsListSectionsFuture())
                        ForEach(state.acceptedEvents, id:\.id) { item in
                            AcceptedEventView(event: item)
                                .transition(.scale(scale: 0.5).combined(with: .opacity))
                        }
                    }
                    if state.declinedEvents.count > 0 {
                        sectionHeader(Localizable.eventsListSectionsDeclined())
                        ForEach(state.invitedEvents, id:\.declineId) { item in
                            EventItemView(event: item)
                                .transition(.scale(scale: 0.5).combined(with: .opacity))
                        }
                    }
                }
                .padding(.bottom, 64)
            }
            //.padding(.bottom, 56)
            VStack {
                //VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 1)
                Rectangle()
                    .fill(Color.r.background.color)
                    .frame(height: 16)
                    .mask {
                        LinearGradient(
                            colors: [Color.black, Color.black.opacity(0)],
                            startPoint: .top,
                            endPoint: .bottom)
                    }
                Spacer()
            }
            VStack {
                Spacer()
                VStack(spacing: 0) {
                    //VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 1)
//                    Rectangle()
//                        .fill(Color.r.background.color)
//                        .frame(height: 8)
//                        .mask {
//                            LinearGradient(
//                                colors: [Color.r.background.color.opacity(0), Color.r.background.color, Color.r.background.color, Color.r.background.color],
//                                startPoint: .top,
//                                endPoint: .bottom)
//                        }
                    Button(action: {
                        state.openNewEvent()
                    }, label: {
                        Text(Localizable.newEventMainActionTitle())
                            .font(.system(size: 20))
                            .foregroundStyle(Color.r.textPrimary.color)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                    })
                    .background(Color.r.actionAccent.color)
                    .clipShape(.rect(cornerRadius: 48, style: .continuous))
                    .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
                    .shadow(color: Color.r.background.color, radius: 5)
                }
            }
        }
        .padding(.horizontal, 4)
        .animation(.customTransition, value: state.invitedEvents)
        .animation(.customTransition, value: state.acceptedEvents)
        .animation(.customTransition, value: state.declinedEvents)
    }
    
    
    func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(Color.r.textSecondary.color)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .padding(.top, 16)
            .transition(.move(edge: .leading))
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
