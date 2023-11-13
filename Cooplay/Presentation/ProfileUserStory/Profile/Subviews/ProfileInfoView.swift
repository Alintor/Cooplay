//
//  ProfileInfoView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 12.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileInfoView: View {
    
    @EnvironmentObject var state: ProfileState
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack {
            ProfileAvatar(profile: state.profile)
                .opacity(state.isShownAvatar ? 1 : 0) // Crutch for transition move animation
                .frame(width: 108, height: 108, alignment: .center)
                .matchedGeometryEffect(id: MatchedAnimations.profileAvatar.name, in: namespace.id)
            Text(state.profile.name)
                .foregroundColor(Color(.textPrimary))
                .font(.system(size: 21, weight: .bold))
                .padding(.top, 16)
                .padding(.bottom, 1)
            if let email = state.profile.email {
                Text(email)
                    .foregroundColor(Color(.textSecondary))
                    .font(.system(size: 17, weight: .medium))
                    .tint(Color(.textSecondary))
            }
        }
    }
}
