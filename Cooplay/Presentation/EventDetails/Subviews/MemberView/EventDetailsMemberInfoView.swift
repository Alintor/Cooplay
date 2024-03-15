//
//  EventDetailsMemberInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsMemberInfoView: View {
    
    @EnvironmentObject var state: EventDetailsState
    @EnvironmentObject var namespace: NamespaceWrapper
    var viewModel: EventDetailsMemberViewModel
    
    var body: some View {
        HStack {
            AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: 32)
                .frame(width: 32, height: 32, alignment: .center)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 4))
                //.matchedGeometryEffect(id: MatchedAnimations.member(viewModel.member.id, eventId: state.event.id).name, in: namespace.id)
            VStack(spacing: 0) {
                HStack {
                    if viewModel.isOwner {
                        Text(viewModel.name)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(R.color.yellow.name))
                        Image(R.image.commonNormalCrown.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color(R.color.yellow.name))
                            .frame(width: 12, height: 12, alignment: .center)
                            .padding(.leading, -4)
                            .padding(.bottom, 2)
                        Spacer()
                    } else {
                        Text(viewModel.name)
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(Color(R.color.textSecondary.name))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                HStack(spacing: 0) {
                    if let details = viewModel.detailsViewModel {
                        details.icon
                            .foregroundColor(Color(R.color.textPrimary.name))
                            .padding(.trailing, 4)
                        Text(details.fullStatus)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color(R.color.textPrimary.name))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(viewModel.status)
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(Color(R.color.textPrimary.name))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            Spacer(minLength: 4)
            ZStack {
                Circle()
                    .foregroundColor(viewModel.statusColor)
                    .frame(width: 24, height: 24, alignment: .center)
                if let icon = viewModel.statusIcon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(R.color.background.name))
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }.padding(.trailing, 14)
        }
        .background(Color(R.color.block.name))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
    
}
