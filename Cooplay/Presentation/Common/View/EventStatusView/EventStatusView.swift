//
//  EventStatusView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventStatusView: View {
    
    static let animationDuration: Double = 0.1

    var viewModel: EventStatusViewModel
    @Binding var isTapped: Bool
    
    let contextMenuHandler: ContextMenuHandler

    var body: some View {
        HStack {
            AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: 32)
                .frame(width: 32, height: 32, alignment: .center)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 4))
            Text(viewModel.title)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color(R.color.textPrimary.name))
            if let details = viewModel.detailsViewModel {
                EventStatusDetailsView(viewModel: details)
            }
            Image(R.image.commonArrowDown.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(R.color.textPrimary.name))
                .frame(width: 10, height: 10, alignment: .center)
                .padding(.top, isTapped ? -2 : 4)
                .rotationEffect(.degrees(isTapped ? 180 : 0))
                .animation(.easeInOut(duration: EventStatusView.animationDuration), value: isTapped)
            Spacer(minLength: 4)
            ZStack {
                Circle()
                    .foregroundColor(viewModel.color)
                    .frame(width: 24, height: 24, alignment: .center)
                if let icon = viewModel.icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(R.color.background.name))
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }
            .padding(.trailing, 14)
        }
        .background(GeometryGetter(delegate: contextMenuHandler))
    }
}
