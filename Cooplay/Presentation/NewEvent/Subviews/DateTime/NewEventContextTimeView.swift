//
//  NewEventContextTimeView.swift
//  Cooplay
//
//  Created by Alexandr on 27.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import SwiftDate

struct NewEventContextTimeView: View {
    
    @EnvironmentObject var state: NewEventState
    @EnvironmentObject var namespace: NamespaceWrapper
    @State var contextPresented = false
    @Binding var showTimeContext: Bool
    @State var timeDate: Date
    
    func close() {
        contextPresented = false
        showTimeContext = false
        state.didSelectTime(timeDate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Haptic.play(style: .medium)
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(contextPresented ? 1 : 0)
                .onTapGesture { close() }
            VStack {
                Spacer()
                if contextPresented {
                    DatePicker(
                        "",
                        selection: $timeDate,
                        in: .init(uncheckedBounds: (
                            (Date() + 5.minutes).rounded(minutes: 5, rounding: .ceil), 
                            (Date() + 3.months).rounded(minutes: 5, rounding: .floor)
                        )),
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .padding(.horizontal)
                    .clipped()
                    .background(Color(.block))
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .transition(.scale(scale: 0, anchor: .bottom).combined(with: .opacity))
                }
                NewEventTimeView(timeValue: timeDate.timeDisplayString, isOpened: contextPresented)
                    .matchedGeometryEffect(id: MatchedAnimations.timeView.name, in: namespace.id)
                    .onTapGesture { close() }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .animation(.fastTransition, value: contextPresented)
        .animation(.customTransition, value: timeDate)
        .onAppear {
            contextPresented = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
    }
}
