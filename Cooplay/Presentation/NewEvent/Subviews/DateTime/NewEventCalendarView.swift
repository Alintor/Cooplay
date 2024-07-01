//
//  NewEventCalendarView.swift
//  Cooplay
//
//  Created by Alexandr on 27.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI
import SwiftDate

struct NewEventCalendarView: View {
    
    @EnvironmentObject var state: NewEventState
    @Binding var showCalendar: Bool
    @State var showPanel = false
    @State var date: Date
    
    func close() {
        showPanel = false
        showCalendar = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            Haptic.play(style: .medium)
        }
    }
    
    var body: some View {
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.2)
                .ignoresSafeArea()
                .opacity(showCalendar ? 1 : 0)
                .onTapGesture { close() }
            VStack {
                Spacer()
                if showPanel {
                    VStack {
                        DatePicker("", selection: $date, in: .init(uncheckedBounds: (Date(), Date() + 3.months)), displayedComponents: .date)
                            .tint(Color(.actionAccent))
                            .datePickerStyle(.graphical)
                            .frame(width: 320)
                        MainActionButton(Localizable.calendarChooseAction(date.toString(.custom("d MMMM")))) {
                            state.didSelectCustomDate(date)
                            close()
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                    }
                    .background(Color(.block))
                    .clipShape(.rect(cornerRadius: 16, style: .continuous))
                    .padding(.horizontal, 24)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
                Spacer()
            }
        }
        .onAppear {
            showPanel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                Haptic.play(style: .medium)
            }
        }
    }
}
