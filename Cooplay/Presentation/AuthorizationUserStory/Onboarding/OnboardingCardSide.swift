//
//  OnboardingCardSide.swift
//  Cooplay
//
//  Created by Alexandr on 03.08.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

enum OnboardingCardSide {
    
    case accepted
    case late
    case decline
    
    var statusTitle: String {
        switch self {
        case .accepted: return Localizable.statusAccepted()
        case .late: return Localizable.statusContextLate()
        case .decline: return Localizable.statusDeclined()
        }
    }
    
    var color: Color {
        switch self {
        case .accepted: return Color(.green)
        case .late: return Color(.yellow)
        case .decline: return Color(.red)
        }
    }
    
    @ViewBuilder var bigAvatar: some View {
        switch self {
        case .accepted:
            Image(.onboardingAvatarAlintor)
                .resizable()
                .frame(width: 44, height: 44, alignment: .center)
                .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        case .late:
            Image(.onboardingAvatarNilo)
                .resizable()
                .frame(width: 44, height: 44, alignment: .center)
                .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        case .decline:
            AvatarItemView(
                viewModel: .init(with: .init(id: "12345", name: "Rika", avatarPath: nil, state: .unknown)),
                diameter: 44
            )
            .frame(width: 44, height: 44, alignment: .center)
            .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        }
    }
    
    @ViewBuilder var middleAvatar: some View {
        switch self {
        case .accepted:
            Image(.onboardingAvatarNilo)
                .resizable()
                .frame(width: 44, height: 44, alignment: .center)
                .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        case .late:
            Image(.onboardingAvatarAlintor)
                .resizable()
                .frame(width: 44, height: 44, alignment: .center)
                .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        case .decline:
            AvatarItemView(
                viewModel: .init(with: .init(id: "123", name: "Gfish", avatarPath: nil, state: .unknown)),
                diameter: 44
            )
            .frame(width: 44, height: 44, alignment: .center)
            .addBorder(Color(.textPrimary), width: 2, cornerRadius: 44)
        }
    }
    
    @ViewBuilder var smallAvatar: some View {
        switch self {
        case .accepted:
            AvatarItemView(
                viewModel: .init(with: .init(id: "12345", name: "Rika", avatarPath: nil, state: .unknown)),
                diameter: 32
            )
            .frame(width: 32, height: 32, alignment: .center)
            .addBorder(Color(.textPrimary), width: 2, cornerRadius: 32)
        case .late:
            AvatarItemView(
                viewModel: .init(with: .init(id: "1", name: "Mera", avatarPath: nil, state: .unknown)),
                diameter: 32
            )
            .frame(width: 32, height: 32, alignment: .center)
            .addBorder(Color(.textPrimary), width: 2, cornerRadius: 32)
        case .decline:
            Image(.onboardingAvatarAlintor)
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
                .addBorder(Color(.textPrimary), width: 2, cornerRadius: 32)
        }
    }
    
    var reaction: String {
        switch self {
        case .accepted: return "😍"
        case .late: return "🤡"
        case .decline: return "😡"
        }
    }
    
    var gameCover: Image {
        switch self {
        case .accepted: return Image(.onboardingGameOverwatch)
        case .late: return Image(.onboardingGameBaldursgate)
        case .decline: return Image(.onboardingGameFortnite)
        }
    }
    
    var gameTitle: String {
        switch self {
        case .accepted: return Localizable.onboardingGameOverwatch()
        case .late: return Localizable.onboardingGameBaldursgate()
        case .decline: return Localizable.onboardingGameFortnite()
        }
    }
    
    var gameDate: String {
        switch self {
        case .accepted: return Localizable.onboardingDateToday()
        case .late: return Localizable.onboardingDateTomorrow()
        case .decline: return Localizable.onboardingDateToday2()
        }
    }
    
    var next: Self {
        switch self {
        case .accepted: return .late
        case .late: return .decline
        case .decline: return .accepted
        }
    }
    
    var prev: Self {
        switch self {
        case .accepted: return .decline
        case .late: return .accepted
        case .decline: return .late
        }
    }
}
