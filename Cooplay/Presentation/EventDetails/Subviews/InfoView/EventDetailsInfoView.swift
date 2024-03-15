//
//  EventDetailsInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI
import struct Kingfisher.KFImage

struct EventDetailsInfoView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack(spacing: 8) {
            gameCover
                .matchedGeometryEffect(id: MatchedAnimations.gameCover(state.event.id).name, in: namespace.id)
            VStack(spacing: 2) {
                Text(state.event.game.name)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(Color(.textPrimary))
                    .frame(maxWidth: .infinity, alignment: .center)
                    //.matchedGeometryEffect(id: MatchedAnimations.gameName(state.event.id).name, in: namespace.id)
                Text(state.event.date.displayString)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(Color(R.color.textSecondary.name))
                    .frame(maxWidth: .infinity, alignment: .center)
                    //.matchedGeometryEffect(id: MatchedAnimations.eventDate(state.event.id).name, in: namespace.id)
            }
            .padding(.horizontal, 8)
        }
    }
    
    var gameCover: some View {
        ZStack {
            if let path = state.event.game.coverPath {
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
    
}
