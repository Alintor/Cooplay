//
//  IntroView.swift
//  Cooplay
//
//  Created by Alexandr on 20.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct IntroView : UIViewControllerRepresentable {

     func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController(
            rootViewController: IntroBuilder().build()
        )
     }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
