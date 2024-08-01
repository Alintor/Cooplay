//
//  ShareActivityView.swift
//  Cooplay
//
//  Created by Alexandr on 12.07.2024.
//  Copyright © 2024 Ovchinnikov. All rights reserved.
//

import UIKit
import SwiftUI

struct ShareActivityView: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareActivityView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareActivityView>) {}

}
