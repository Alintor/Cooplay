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
            Color.r.block.color
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
            } label: {
                Text(Localizable.statusAcceptedShort())
                    .font(.system(size: 20))
                    .foregroundStyle(Color.r.block.color)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.r.green.color)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            Button {
                print("more")
            } label: {
                Text("Еще")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.r.textPrimary.color)
                    .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
            .background(Color.r.shapeBackground.color)
            .clipShape(.rect(cornerRadius: 20, style: .continuous))

        }
    }
}

#Preview {
    InvitedEventView(event: Event.mock)
}
