//
//  EventDetailsAddMemberView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 15.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EventDetailsAddMemberView: View {
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .foregroundColor(Color(R.color.shapeBackground.name))
                Image(R.image.commonPlus.name)
                    .resizable()
                    .foregroundColor(Color(R.color.actionAccent.name))
                    .padding(4)
            }
            .frame(width: 32, height: 32, alignment: .center)
            .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 4))
            Text(R.string.localizable.eventDetailsAddMemberLabelTitle())
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(Color(R.color.actionAccent.name))
            Spacer(minLength: 4)
        }
        .background(Rectangle().foregroundColor(Color(R.color.block.name)))
        .cornerRadius(12)
    }
}
