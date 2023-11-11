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
                    .foregroundStyle(Color.r.textPrimary.color)
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text(Localizable.eventsListEmptySateDescription())
                    .foregroundStyle(Color.r.textSecondary.color)
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
            }
            Button(action: {
                newEventAction?()
            }, label: {
                Text(Localizable.newEventMainActionTitle())
                    .font(.system(size: 20))
                    .foregroundStyle(Color.r.textPrimary.color)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 24)
            })
            .background(Color.r.actionAccent.color)
            .clipShape(.rect(cornerRadius: 48, style: .continuous))
            .scaleEffect(0.7)
            .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
            .padding(.bottom, 64)
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    EmptyEvents()
}
