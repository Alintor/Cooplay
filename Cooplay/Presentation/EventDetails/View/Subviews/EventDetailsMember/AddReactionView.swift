//
//  AddReactionView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AddReactionView: View {
    
    @EnvironmentObject var state: EventDetailsState
    let member: User
    let isOwner: Bool
    
    var body: some View {
        Image(R.image.commonReaction.name)
            .foregroundColor(Color(R.color.textSecondary.name))
            .frame(width: 24, height: 24, alignment: .center)
            .padding(EdgeInsets(
                top: isOwner ? 8 : 3,
                leading: isOwner ? 12 : 7,
                bottom: isOwner ? 8 : 3,
                trailing: isOwner ? 12 : 7
            ))
            .background(Color(R.color.block.name))
            .cornerRadius(20)
            .onTapGesture {
                //output?.reactionTapped(for: member, delegate: reactionMenuHandler)
            }
    }
}
