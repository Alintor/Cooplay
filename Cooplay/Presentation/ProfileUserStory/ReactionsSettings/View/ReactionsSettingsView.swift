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
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    
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
                ZStack {
                    ScrollView {
                        LazyVStack {
                            ForEach(Array(output.getAllReactions().enumerated()), id: \.element) { index, items in
                                HStack {
                                    Text(TextValue.categoryName(index).uppercased())
                                        .font(.system(size: 13))
                                        .foregroundColor(Color(R.color.textSecondary.name))
                                    Spacer()
                                }
                                LazyVGrid(columns: columns, spacing: 6) {
                                    ForEach(items, id: \.self) { item in
                                        VStack(spacing: 2) {
                                            Text(item)
                                                .font(.system(size: 40))
                                                .onTapGesture {
                                                    output.didSelectReaction(item, for: selectedIndex)
                                                }
                                            Circle()
                                                .foregroundColor(Color(R.color.textSecondary.name))
                                                .frame(width: 4, height: 4, alignment: .center)
                                                .opacity(reactions.contains(item) ? 1 : 0)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                    }
                    VStack {
                        LinearGradient(
                            gradient: Gradient(
                                colors: [Color(R.color.background.name), Color(R.color.background.name).opacity(0)]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 16)
                        Spacer()
                    }
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
    
    static func categoryName(_ index: Int) -> String {
        NSLocalizedString("reactionsSettings.category.\(index).title", comment: "")
    }
    static let message = R.string.localizable.reactionsSettingsMessage()
}
