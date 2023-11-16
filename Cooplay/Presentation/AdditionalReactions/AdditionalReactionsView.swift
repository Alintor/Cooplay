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
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var state: AdditionalReactionsState
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color(R.color.background.name)
                .edgesIgnoringSafeArea(.all)
            AllReactionsListView(allReactions: state.getAllReactions(), userReactions: $state.selectedReactions) { reaction in
                state.didSelectReaction(state.selectedReactions.contains(reaction) ? nil : reaction)
                dismiss()
            }
        }
    }
}
