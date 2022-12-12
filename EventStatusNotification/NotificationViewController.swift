//
//  NotificationViewController.swift
//  EventStatusNotification
//
//  Created by Alexandr Ovchinnikov on 23.11.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI
import Firebase
import FirebaseFunctions

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    private let viewModel = EventDetailsNotificationViewModel()
    private let stackView = UIStackView()
    
    private let firebaseFunctions: Functions = Functions.functions()
    
    override var canBecomeFirstResponder: Bool {
      return true
    }
    
    private var event: Event!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childView = UIHostingController(rootView: EventDetailsNotificationView(viewModel: viewModel))
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
          
        stackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        stackView.addArrangedSubview(childView.view)
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard
            let eventData = userInfo["event"] as? Data,
            let event = try? JSONDecoder().decode(Event.self, from: eventData)
        else { return }
        self.event = event
        
        viewModel.update(with: event)
        
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        becomeFirstResponder()
        completion(.doNotDismiss)
    }

}
