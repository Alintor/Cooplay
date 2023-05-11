//
//  EditProfileViewController.swift
//  Cooplay
//
//  Created by Alexandr on 11.05.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI
import Combine

final class EditProfileViewController: UIHostingController<EditProfileView> {

    private weak var output: EditProfileViewOutput?
    
    init(contentView: EditProfileView, output: EditProfileViewOutput?) {
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
