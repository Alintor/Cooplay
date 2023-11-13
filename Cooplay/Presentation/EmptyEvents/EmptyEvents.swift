//
//  EmptyEvents.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EmptyEvents: View {
    
    var newEventAction: (() -> Void)?
    @EnvironmentObject var namespace: NamespaceWrapper
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(R.image.eventsEmpty.name)
            VStack(spacing: 4) {
                Text(Localizable.eventsListEmptySateTitle())
                    .foregroundStyle(Color(.textPrimary))
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text(Localizable.eventsListEmptySateDescription())
                    .foregroundStyle(Color(.textSecondary))
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
            }
            Button(action: {
                newEventAction?()
            }, label: {
                Label(Localizable.newEventMainActionTitle(), systemImage: "plus")
                    .font(.system(size: 20))
                    .foregroundStyle(Color(.textPrimary))
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
            })
            .background(Color(.actionAccent))
            .clipShape(.rect(cornerRadius: 48, style: .continuous))
            .scaleEffect(0.7)
            .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    EmptyEvents()
}
