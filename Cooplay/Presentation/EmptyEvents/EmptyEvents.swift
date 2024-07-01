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
    @EnvironmentObject var coordinator: HomeCoordinator
    @State var offset: CGFloat = 0
    
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
            .offset(x: 0, y: offset)
            .matchedGeometryEffect(id: MatchedAnimations.newEventButton.name, in: namespace.id)
            .animation(.interpolatingSpring(stiffness: 250, damping: 20), value: offset)
            .highPriorityGesture(DragGesture()
                .onChanged { state in
                    guard state.translation.height > 0 && !coordinator.showArkanoid  else { return }

                    if offset >= 200 {
                        Haptic.play(style: .heavy)
                        coordinator.showArkanoid = true
                    } else {
                        Haptic.play(style: .soft)
                        offset = state.translation.height * 0.8
                    }
                }
                .onEnded({ _ in
                    if !coordinator.showArkanoid {
                        offset = 0
                        Haptic.play(style: .heavy)
                    }
                })
            )
            Spacer()
        }
        .padding(.horizontal, 32)
        .onChange(of: coordinator.showArkanoid) { showGame in
            if !showGame {
                offset = 0
                Haptic.play(style: .medium)
            }
        }
//        .fullScreenCover(isPresented: $showGame) {
//            ArcanoidView().ignoresSafeArea()
//        }
    }
}

#Preview {
    EmptyEvents()
}
