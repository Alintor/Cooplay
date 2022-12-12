//
//  EventStatusService.swift
//  EventStatusNotification
//
//  Created by Alexandr Ovchinnikov on 06.12.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFunctions

class EventStatusService {
    
    private let firestore: Firestore = Firestore.firestore()
    private let firebaseFunctions: Functions = Functions.functions()
    
    func changeStatus(
        for event: Event,
        completion: @escaping () -> Void
    ) {
        var data: [AnyHashable: Any] = [
            "members.\(event.me.id).state": event.me.state.rawValue as Any,
            "members.\(event.me.id).reactions": FieldValue.delete()
        ]
        data["members.\(event.me.id).lateness"] = event.me.lateness ?? FieldValue.delete()
        firestore.collection("Events").document(event.id).updateData(data) { [weak self] (error) in
            if let error = error {
                completion()
            } else {
                self?.sendChangeStatusNotification(for: event)
                completion()
            }
        }
    }
    
    private func sendChangeStatusNotification(for event: Event) {
        firebaseFunctions.httpsCallable("sendChangeStatusNotification").call(event.dictionary) { (_, _) in }
    }
}
