//
//  SearchGameView.swift
//  Cooplay
//
//  Created by Alexandr on 16.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchGameView : UIViewControllerRepresentable {
    
    let selectedGame: Game
    let selectionHandler: ((_ game: Game) -> Void)?

     func makeUIViewController(context: Context) -> some UIViewController {
         let navigationController = UINavigationController(rootViewController: SearchGameBuilder().build(
             offtenGames: nil,
             selectedGame: selectedGame,
             selectionHandler: selectionHandler
         ))
         return navigationController
     }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
