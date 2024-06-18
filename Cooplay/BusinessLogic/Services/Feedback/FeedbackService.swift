//
//  FeedbackService.swift
//  Cooplay
//
//  Created by Alexandr on 17.06.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import SwiftDate

enum FeedbackServiceError: Error {
    
    case sendFeedback
}

extension FeedbackServiceError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .sendFeedback: return Localizable.writeToUsFailureAlert()
        }
    }
}

protocol FeedbackServiceType {
    
    func sendFeedback(_ text: String) async throws
}

final class FeedbackService {
    
    private let firebaseAuth: Auth
    private let firestore: Firestore
    
    init(firebaseAuth: Auth, firestore: Firestore) {
        self.firebaseAuth = firebaseAuth
        self.firestore = firestore
    }
}

extension FeedbackService: FeedbackServiceType {
    
    func sendFeedback(_ text: String) async throws {
        guard let userId = firebaseAuth.currentUser?.uid else { throw FeedbackServiceError.sendFeedback }
        
        let feedback = await FeedbackRequest(
            message: text,
            userId: userId,
            date: Date().toString(.custom(GlobalConstant.Format.Date.serverDate.rawValue)),
            platform: UIDevice.current.systemName,
            osVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        )
        guard let data = feedback.dictionary else { throw FeedbackServiceError.sendFeedback }
        
        try await firestore.collection("Feedback").addDocument(data: data)
    }
}
