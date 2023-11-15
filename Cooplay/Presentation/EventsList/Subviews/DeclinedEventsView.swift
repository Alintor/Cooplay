//
//  DeclinedEventsView.swift
//  Cooplay
//
//  Created by Alexandr on 13.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct DeclinedEventsView: View {
    
    @EnvironmentObject var state: EventsListState
    @EnvironmentObject var namespace: NamespaceWrapper
    @State var isDeclinedEventsStack = true
    
    var body: some View {
        VStack {
            HStack {
                EventsSectionHeader(title: Localizable.eventsListSectionsDeclined())
                Spacer()
                if !isDeclinedEventsStack {
                    Label(Localizable.eventsListDeclinedEventsHide(), systemImage: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(.textSecondary))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(.shapeBackground))
                        .clipShape(.capsule)
                        .padding(.top, 16)
                        .padding(.trailing, 8)
                        .zIndex(-1)
                        .transition(.move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.5, anchor: .bottom)))
                        .onTapGesture {
                            isDeclinedEventsStack = true
                        }
                }
            }
            if isDeclinedEventsStack, state.declinedEvents.count > 1 {
                declinedStack
                    .zIndex(1)
                .onTapGesture {
                    isDeclinedEventsStack = false
                }
            } else {
                ForEach(Array(state.declinedEvents.enumerated()), id:\.offset) { index, item in
                    EventItemView(event: item)
                        .matchedGeometryEffect(id: item.declineId, in: namespace.id)
                }
            }
        }
        .animation(.stackTransition, value: isDeclinedEventsStack)
    }
    
    // MARK: - Subviews
    
    var declinedStack: some View {
        ZStack {
            ForEach(Array(state.declinedEvents.enumerated()), id:\.offset) { index, item in
                declinedStackItem(event: item, index: CGFloat(index), maxIndex: Double(state.declinedEvents.count - 1))
                    .zIndex(Double(state.declinedEvents.count - index))
            }
        }
    }
    
    func declinedStackItem(event: Event, index: Double, maxIndex: Double) -> some View {
        EventItemView(event: event)
            .matchedGeometryEffect(id: event.declineId, in: namespace.id)
            .shadow(radius: 5)
            .padding(.bottom, (index) * -8)
            .scaleEffect(1 - ((index) / 10), anchor: .bottom)
            .disabled(true)
    }
    
}
