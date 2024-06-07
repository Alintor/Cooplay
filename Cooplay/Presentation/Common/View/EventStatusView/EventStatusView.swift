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

    var body: some View {
        HStack {
            AvatarItemView(viewModel: viewModel.avatarViewModel, diameter: 32)
                .frame(width: 32, height: 32, alignment: .center)
                .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 4))
            Text(viewModel.title)
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color(R.color.textPrimary.name))
                .animation(.fastTransition)
                .transition(.scale.combined(with: .opacity))
                .id("StatusView" + viewModel.title)
            if let details = viewModel.detailsViewModel {
                EventStatusDetailsView(viewModel: details)
                    .transition(.scale.combined(with: .opacity))
            }
            Image(R.image.commonArrowDown.name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(R.color.textPrimary.name))
                .frame(width: 10, height: 10, alignment: .center)
                .padding(.top, isTapped ? -2 : 4)
                .rotationEffect(.degrees(isTapped ? 180 : 0))
                .animation(.customTransition, value: isTapped)
            Spacer()
            ZStack {
                Circle()
                    .foregroundColor(viewModel.color)
                    .frame(width: 24, height: 24, alignment: .center)
                viewModel.icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color(R.color.background.name))
                    .frame(width: 24, height: 24, alignment: .center)
            }
            .padding(.trailing, 14)
        }
    }
}
