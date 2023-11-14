//
//  ReactionsListView.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 18.11.2021.
//  Copyright © 2021 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct ReactionsListView: View {
    
    var reactions: [ReactionViewModel]
    let member: User
    var needAddButton: Bool {
        !reactions.contains(where: { $0.isOwner })
    }

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            if needAddButton {
                AddReactionView(member: member, isOwner: false)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 4))
                    .animation(.easeInOut(duration: 0.2))
                    .transition(.scale.combined(with: .opacity))
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if self.reactions.isEmpty {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if self.reactions.isEmpty {
                            height = 0 // last item
                        }
                        return result
                    })
            }
            
            ForEach(self.reactions, id: \.user.name) { reaction in
                self.item(for: reaction)
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 4))
                    .transition(.scale.combined(with: .opacity))
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if reaction.user == self.reactions.last!.user {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if reaction.user == self.reactions.last!.user {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for reaction: ReactionViewModel) -> some View {
        ReactionView(viewModel: reaction, member: member, isOwner: false)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
