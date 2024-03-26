//
//  ProfileNavigationView.swift
//  Cooplay
//
//  Created by Alexandr on 29.02.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ProfileNavigationView: View {
    
    @EnvironmentObject var namespace: NamespaceWrapper
    @EnvironmentObject var coordinator: ProfileCoordinator
    let title: String
    var isBackButton: Binding<Bool>
    let backAction: (() -> Void)?
    
    init(title: String, isBackButton: Binding<Bool>, backAction: (() -> Void)? = nil) {
        self.title = title
        self.isBackButton = isBackButton
        self.backAction = backAction
    }
    
    var body: some View {
        ZStack {
            HStack{
                Spacer()
                TitleView(text: title)
                Spacer()
            }
            HStack {
                BackCloseIcon(isBack: isBackButton)
                    .foregroundColor(Color(.textSecondary))
                    .matchedGeometryEffect(id: MatchedAnimations.closeButton.name, in: namespace.id)
                    .frame(width: 32, height: 32, alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let backAction {
                            backAction()
                        } else {
                            coordinator.open(.menu)
                        }
                    }
                Spacer()
            }
        }
        .padding()
        //.animation(.customTransition, value: isBackButton)
    }
    
}
