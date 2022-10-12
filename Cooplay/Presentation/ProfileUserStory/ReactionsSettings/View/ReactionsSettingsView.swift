//
//  ReactionsSettingsView.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionsSettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ReactionsSettingsViewModel
    var output: ReactionsSettingsViewOutput
    @State var reactions: [String]
    @State var selectedIndex: Int = 0
    
    // MARK: - Init
    
    init(viewModel: ReactionsSettingsViewModel, output: ReactionsSettingsViewOutput) {
        self.viewModel = viewModel
        self.output = output
        reactions = viewModel.reactions
    }
    
    // MARK: - Body
    
    var body: some View {
        return ZStack {
            Color(R.color.background.name)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    ForEach(Array(reactions.enumerated()), id: \.element) { index, item in
                        Text(reactions[index])
                            .font(.system(size: 40))
                            .opacity(selectedIndex == index ? 1 : 0.5)
                            
                            .transition(AnyTransition.scale.animation(.interpolatingSpring(stiffness: 450, damping: 20)))
                            .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.2)))
                            .onTapGesture {
                                selectedIndex = index
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                HStack {
                    Text(TextValue.message)
                        .foregroundColor(Color(R.color.textPrimary.name))
                        .font(.system(size: 21, weight: .bold))
                    Spacer()
                }
                
                .padding(.leading, 16)
                .padding(.top, 20)
                .padding(.bottom, 8)
                AllReactionsListView(allReactions: output.getAllReactions(), userReactions: $reactions) { reaction in
                    output.didSelectReaction(reaction, for: selectedIndex)
                }
            }
        }
        .onReceive(viewModel.$reactions) { reactions in
            withAnimation {
                self.reactions = reactions
            }
        }
    }
}


// MARK: - Constants

private enum TextValue {

    static let message = R.string.localizable.reactionsSettingsMessage()
}
