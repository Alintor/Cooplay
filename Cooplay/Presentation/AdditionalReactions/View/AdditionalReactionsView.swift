//
//  AdditionalReactionsView.swift
//  Cooplay
//
//  Created by Alexandr on 10.10.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct AdditionalReactionsView: View {
    
    // MARK: - Properties
    
    var output: AdditionalReactionsViewOutput
    @State var selectedReactions: [String]
    
    // MARK: - Init
    
    init(output: AdditionalReactionsViewOutput, selectedReaction: String?) {
        self.output = output
        if let selectedReaction = selectedReaction {
            self.selectedReactions = [selectedReaction]
        } else {
            self.selectedReactions = []
        }
    }
    
    // MARK: - Body
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(R.color.background.name)
                    .edgesIgnoringSafeArea(.all)
                AllReactionsListView(allReactions: output.getAllReactions(), userReactions: $selectedReactions) { reaction in
                    output.didSelectReaction(selectedReactions.contains(reaction) ? nil : reaction)
                }
            }
            .navigationTitle(R.string.localizable.additionalReactionsTitle())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(R.string.localizable.commonCancel()) {
                        output.didTapCloseButton()
                    }

                }
            }
        }
    }
}
