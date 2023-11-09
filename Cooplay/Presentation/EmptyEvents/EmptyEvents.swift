//
//  EmptyEvents.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct EmptyEvents: View {
    
    @State var showNewEvent = false
    
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
            Button {
                showNewEvent = true
            } label: {
                Text("Создать событие")
                    .foregroundStyle(Color.r.textPrimary.color)
                    .font(.system(size: 17))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .background(Color(R.color.actionAccent.name))
            .cornerRadius(20)
            .padding(.bottom, 64)
            Spacer()
        }
        .padding(.horizontal, 32)
        .fullScreenCover(isPresented: $showNewEvent, content: {
            NewEventView()
                .ignoresSafeArea()
        })
    }
}

#Preview {
    EmptyEvents()
}
