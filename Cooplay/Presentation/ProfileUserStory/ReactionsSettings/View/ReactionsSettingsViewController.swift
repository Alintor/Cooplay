//
//  ReactionsSettingsViewController.swift
//  Cooplay
//
//  Created by Alexandr on 02.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Combine

final class ReactionsSettingsViewController: UIHostingController<ReactionsSettingsView> {

    private weak var output: ReactionsSettingsViewOutput?
    
    init(contentView: ReactionsSettingsView, output: ReactionsSettingsViewOutput?) {
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
    
    private func setupView() {
        isModalInPresentation = true
        navigationItem.title = Text.title
    }
}


// MARK: - Constants

private enum Text {
    
    static let title = R.string.localizable.reactionsSettingsTitle()
}
