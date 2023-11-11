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
    
    var body: some View {
        ZStack {
            Color.r.shapeBackground.color
            HStack(spacing: 12) {
                gameCover
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
    }
    
    var gameCover: some View {
        ZStack {
            if let path = event.game.coverPath {
                KFImage(URL(string: path))
                    .placeholder({
                        Image(R.image.commonGameCover.name)
                    })
                    .resizable()
                    .frame(width: 70, height: 90, alignment: .center)
                    .cornerRadius(12)
            } else {
                Image(R.image.commonGameCover.name)
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
                .foregroundColor(Color.r.textPrimary.color)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(event.date.displayString)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Color.r.textSecondary.color)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var members: some View {
        HStack(spacing:-6) {
            ForEach(event.members.sorted(by: { $0.name < $1.name }), id:\.name) { item in
                AvatarItemView(viewModel: .init(with: item), diameter: 30)
                    .frame(width: 30, height: 30, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.r.shapeBackground.color, lineWidth: 2)
                    )
            }
            Spacer()
        }
    }
}

#Preview {
    EventItemView(event: Event.mock)
}

extension Event {
    
    static var mock: Event {
        Event(
            id: "12345",
            game: Game(
                slug: "over",
                name: "Overwatch 2",
                coverPath: "https://thumbnails.pcgamingwiki.com/3/3b/Overwatch_2_cover.jpg/300px-Overwatch_2_cover.jpg",
                previewImagePath: nil
            ),
            date: Date(),
            members: [
                User(id: "1", name: "Nilo", avatarPath: nil, state: .accepted, lateness: nil, isOwner: true, reactions: nil),
                User(id: "2", name: "Rika", avatarPath: nil, state: .maybe, lateness: nil, isOwner: true, reactions: nil)
            ],
            me: User(id: "3", name: "Alintor", avatarPath: nil, state: .accepted, lateness: nil, isOwner: true, reactions: nil)
        )
    }
}
