//
//  InvitedEventView.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct InvitedEventView: View {
    
    @EnvironmentObject var state: EventsListState
    let event: Event
    
    var body: some View {
        ZStack {
            Color(.block)
            VStack(spacing: 2) {
                EventItemView(event: event)
                buttons
            }
            .padding(4)
        }
        .frame(height: 170)
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
    }
    
    var buttons: some View {
        HStack(spacing: 2) {
            Button {
                state.changeStatus(.accepted, for: event)
                Haptic.play(style: .soft)
            } label: {
                Text(Localizable.statusAcceptedShort())
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.block))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(.green))
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
            }
            Button {
                print("more")
                state.changeStatus(.declined, for: event)
            } label: {
                Text(Localizable.eventsListInvitedEventMore())
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.textPrimary))
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(Color(.shapeBackground))
                    .clipShape(.rect(cornerRadius: 20, style: .continuous))
            }

        }
    }
}

#Preview {
    InvitedEventView(event: Event.mock)
}
