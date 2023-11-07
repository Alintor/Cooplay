//
//  ProfileViewController.swift
//  Cooplay
//
//  Created by Alexandr Ovchinnikov on 16/06/2020.
//

import SwiftUI
import Combine

final class ProfileViewController: UIHostingController<ProfileOldView> {
    
    init(contentView: ProfileOldView) {
        super.init(rootView: contentView)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
