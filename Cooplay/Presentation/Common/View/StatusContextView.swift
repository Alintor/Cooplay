//
//  StatusContextView.swift
//  Cooplay
//
//  Created by Alexandr on 13.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct StatusContextView: View {
    
    let event: Event
    let handler: ((_ status: User.Status) -> Void)?
    @State var showTimePanel: Bool = false
    @State var timePanelType: TimeCarouselConfiguration.TimeType = .suggestion
    @State var initialTimeValue: Int = 0
    
    var body: some View {
        ZStack {
            if showTimePanel {
                TimeCarouselPanelView(
                    configuration: .init(
                        type: timePanelType,
                        date: event.date,
                        initialValue: initialTimeValue
                    ),
                    cancelHandler: { showTimePanel = false },
                    confirmHandler: { handler?($0) }, 
                    dateHandler: nil
                )
                .frame(height: 200)
                .transition(.move(edge: .top))
            } else {
                VStack(spacing: 0) {
                    ForEach(event.contextItems, id:\.id) { item in
                        itemView(item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                handleStatus(item)
                            }
                    }
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.interpolatingSpring(duration: 0.3), value: showTimePanel)
    }
    
    // MARK: - Subviews
    
    func itemView(_ status: User.Status) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(status.contextTitle(event))
                    .foregroundStyle(status.titleColor)
                    .font(.system(size: 20))
                Spacer()
                status.contextIcon
                    .foregroundStyle(status.iconColor)
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 20)
            .padding(.trailing, 14)
            .padding(.vertical, 16)
            separator
        }
    }
    
    var separator: some View {
        Rectangle()
            .foregroundColor(Color(.textPrimary).opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 1 / UIScreen.main.scale)
    }
    
    // MARK: - Methods
    
    func handleStatus(_  status: User.Status) {
        switch status {
        case .suggestDate:
            if case .suggestDate(let minutes) = event.me.status {
                initialTimeValue = minutes
            }
            timePanelType = .suggestion
            showTimePanel = true
        case .late:
            if case .late(let minutes) = event.me.status {
                initialTimeValue = minutes ?? 0
            }
            timePanelType = .latness
            showTimePanel = true
        default:
            handler?(status)
        }
    }
}

#Preview {
    StatusContextView(event: Event.mock, handler: nil)
}


private extension Event {
    
    var contextItems: [User.Status] {
        return !isAgreed 
            ? User.Status.agreementStatuses
            : (isActive ? User.Status.confirmationStatuses : User.Status.agreementStatuses)
    }
}

extension User.Status {
    
    var id: Int {
        switch self {
        case .accepted: return 1
        case .ontime: return 2
        case .maybe: return 3
        case .late: return 4
        case .suggestDate: return 5
        case .declined: return 6
        case .unknown: return 7
        }
    }
    
    
    func contextTitle(_ event: Event) -> String {
        switch self {
        case .suggestDate:
            return Localizable.statusSuggestDateShort()
        default:
            return self.title(event: event)
        }
    }
        
        var contextIcon: Image {
            Image(uiImage: self.icon()!)
        }
        
        var titleColor: Color {
            switch self {
            case .declined:
                return Color(.red)
            default:
                return Color(.textPrimary)
            }
        }
        
        var iconColor: Color {
            switch self {
            case .declined:
                return Color(.red)
            default:
                return Color(.textPrimary)
            }
        }
}
