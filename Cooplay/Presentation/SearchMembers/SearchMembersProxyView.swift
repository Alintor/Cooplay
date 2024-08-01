//
//  SearchMembersView.swift
//  Cooplay
//
//  Created by Alexandr on 17.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct SearchMembersProxyView : UIViewControllerRepresentable {
    
    let eventId: String
    let selectedMembers: [User]
    let oftenMembers: [User]?
    let isEditing: Bool
    let selectionHandler: ((_ members: [User]) -> Void)?

     func makeUIViewController(context: Context) -> some UIViewController {
         let navigationController = UINavigationController(rootViewController: SearchMembersBuilder().build(
            eventId: eventId,
            offtenMembers: nil,
            selectedMembers: selectedMembers,
            isEditing: isEditing,
            selectionHandler: selectionHandler
         ))
         return navigationController
     }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
