//
//  EventDetailsEditInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsEditInfoView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(state.event.game.name)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.actionAccent))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
                    .matchedGeometryEffect(id: MatchedAnimations.gameName(state.event.id).name, in: namespace.id)
                Spacer()
                Image(.commonArrowDown)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color(.textSecondary))
                    .padding(.trailing, 16)
            }
            .background(Rectangle().foregroundColor(Color(.block)))
            .cornerRadius(12)
            .onTapGesture {
                state.showChangeGameSheet = true
            }
            
            HStack {
                Text(state.event.date.displayString)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(.actionAccent))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
                    .matchedGeometryEffect(id: MatchedAnimations.eventDate(state.event.id).name, in: namespace.id)
                Spacer()
                Image(.commonArrowDown)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(Color(.textSecondary))
                    .padding(.trailing, 16)
            }
            .background(Rectangle().foregroundColor(Color(.block)))
            .cornerRadius(12)
            .onTapGesture {
                //output?.changeDateAction(delegate: contextHandler)
            }
        }
    }
}

