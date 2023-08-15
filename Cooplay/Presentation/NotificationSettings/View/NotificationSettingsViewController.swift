//
//  NotificationSettingsViewController.swift
//  Cooplay
//
//  Created by Alexandr on 01/08/2023.
//

import SwiftUI
import Combine

final class NotificationSettingsViewController: UIHostingController<NotificationSettingsView> {

    private weak var output: NotificationSettingsViewOutput?
    
    init(contentView: NotificationSettingsView, output: NotificationSettingsViewOutput?) {
        self.output = output
        super.init(rootView: contentView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        output?.didLoad()
    }
    
    // MARK: - Private
    
    private func setupView() { }
    
}
