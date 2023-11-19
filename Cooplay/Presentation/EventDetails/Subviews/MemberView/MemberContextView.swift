//
//  MemberContextView.swift
//  Cooplay
//
//  Created by Alexandr on 19.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

enum MemberContextAction {
    
    case makeOwner
    case remove
}

struct MemberContextView: View {
    
    let handler: ((_ action: MemberContextAction) -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(MemberContextAction.ownerActions, id:\.id) { action in
                itemView(action)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        handler?(action)
                    }
            }
        }
        .background(Color(.block))
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
    }
    
    // MARK: - Subviews
    
    func itemView(_ action: MemberContextAction) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(action.title)
                    .foregroundStyle(Color(.textPrimary))
                    .font(.system(size: 20))
                Spacer()
                action.icon
                    .foregroundStyle(action.iconColor)
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
}

extension MemberContextAction {
    
    static let ownerActions: [MemberContextAction] = [.makeOwner, .remove]
    
    var id: Int {
        switch self {
        case .makeOwner: return 1
        case .remove: return 2
        }
    }
    
    var title: String {
        switch self {
        case .makeOwner:
            return Localizable.eventMemberMenuItemMakeOwner()
        case .remove:
            return Localizable.eventMemberMenuItemDelete()
        }
    }
    
    var icon: Image {
        switch self {
        case .makeOwner:
            return Image(.commonNormalCrown)
        case .remove:
            return Image(.commonDelete)
        }
    }
    
    var iconColor: Color {
        switch self {
        case .makeOwner:
            return Color(.yellow)
        case .remove:
            return Color(.red)
        }
    }
}

#Preview {
    StatusContextView(event: Event.mock, handler: nil)
}
