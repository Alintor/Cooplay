//
//  AllReactionsListView.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AllReactionsListView: View {
    
    let allReactions: [[String]]
    @Binding var userReactions: [String]
    var selectionHandler: ((_ reaction: String) -> Void)?
    
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(Array(allReactions.enumerated()), id: \.element) { index, items in
                        if (items.isEmpty) {
                            EmptyView()
                        } else {
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
                                                selectionHandler?(item)
                                            }
                                        Circle()
                                            .foregroundColor(Color(R.color.textSecondary.name))
                                            .frame(width: 4, height: 4, alignment: .center)
                                            .opacity(userReactions.contains(item) ? 1 : 0)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .clipped()
            .ignoresSafeArea(edges: .bottom)
//            VStack {
//                LinearGradient(
//                    gradient: Gradient(
//                        colors: [Color(R.color.background.name), Color(R.color.background.name).opacity(0)]
//                    ),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .frame(height: 16)
//                Spacer()
//            }
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
