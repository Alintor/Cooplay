//
//  NewEventView.swift
//  Cooplay
//
//  Created by Alexandr on 09.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct NewEventProxyView : UIViewControllerRepresentable {
    
    var closeHandler: (() -> Void)?

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
     }

     func makeUIViewController(context: Context) -> some UIViewController {
         return UINavigationController(rootViewController: NewEventBuilder().build(closeHandler: closeHandler))
     }
}
