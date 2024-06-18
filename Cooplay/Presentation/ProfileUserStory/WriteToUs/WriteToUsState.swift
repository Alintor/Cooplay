//
//  WriteUsState.swift
//  Cooplay
//
//  Created by Alexandr on 17.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Combine
import SwiftUI

final class WriteToUsState: ObservableObject {
    
    // MARK: - Properties
    
    private let store: Store
    private let feedbackService: FeedbackServiceType
    @Published var feedbackText: String = ""
    @Published var showProgress: Bool = false
    var isReady: Bool {
        !feedbackText.isEmpty
    }
    var close: (() -> Void)?
    
    // MARK: - Init
    
    init(store: Store, feedbackService: FeedbackServiceType) {
        self.store = store
        self.feedbackService = feedbackService
    }
    
    // MARK: - Methods
    
    func trySendFeedback() {
        showProgress = true
        Task {
            do {
                try await feedbackService.sendFeedback(feedbackText)
                store.dispatch(.showNotificationBanner(.init(title: Localizable.writeToUsSuccessAlert(), type: .success)))
                await MainActor.run {
                    showProgress = false
                    close?()
                }
            } catch {
                await MainActor.run {
                    showProgress = false
                    store.dispatch(.showNetworkError(FeedbackServiceError.sendFeedback))
                }
            }
        }
    }
    
}
