//
//  ReactionsSettingsViewModel.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import SwiftUI

class ReactionsSettingsViewModel: ObservableObject {
    
    @Published var reactions: [String] = []
    private let generator = UIImpactFeedbackGenerator(style: .medium)
}

extension ReactionsSettingsViewModel: ReactionsSettingsViewInput {
    
    func updateReactions(_ reactions: [String]) {
        generator.prepare()
        if !self.reactions.isEmpty && self.reactions != reactions {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.generator.impactOccurred()
            }
        }
        self.reactions = reactions
    }
}
