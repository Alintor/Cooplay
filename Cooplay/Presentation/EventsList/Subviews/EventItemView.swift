//
//  EventItemView.swift
//  Cooplay
//
//  Created by Alexandr on 10.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct EventItemView: View {
    
    let event: Event
    @EnvironmentObject var state: EventsListState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        ZStack {
            Color(.shapeBackground)
            HStack(spacing: 12) {
                gameCover
                    .matchedGeometryEffect(id: MatchedAnimations.gameCover(event.id).name, in: namespace.id)
                VStack(spacing: 14) {
                    eventInfo
                    members
                }
                .padding(.bottom, 2)
            }
            .padding(8)
        }
        .frame(height: 106)
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            state.selectEvent(event)
        }
        .onLongPressGesture {
            state.deleteEvent(event)
        }
    }
    
    var gameCover: some View {
        ZStack {
            if let path = event.game.coverPath {
                KFImage(URL(string: path))
                    .placeholder({
                        Image(.commonGameCover)
                    })
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(12)
            } else {
                Image(.commonGameCover)
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(12)
            }
        }
    }
    
    var eventInfo: some View {
        VStack(spacing: 2) {
            Text(event.game.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(.textPrimary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .matchedGeometryEffect(id: MatchedAnimations.gameName(event.id).name, in: namespace.id)
            Text(event.date.displayString)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color(.textSecondary))
                .frame(maxWidth: .infinity, alignment: .leading)
                .matchedGeometryEffect(id: MatchedAnimations.eventDate(event.id).name, in: namespace.id)
        }
    }
    
    var members: some View {
        HStack(spacing:-6) {
            ForEach(event.members.sorted(by: { $0.name < $1.name }), id:\.name) { item in
                AvatarItemView(viewModel: .init(with: item), diameter: 30)
                    .frame(width: 30, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.shapeBackground), lineWidth: 2)
                    )
                    .matchedGeometryEffect(id: MatchedAnimations.member(item.id, eventId: event.id).name, in: namespace.id)
            }
            Spacer()
        }
    }
}

#Preview {
    EventItemView(event: Event.mock)
}
