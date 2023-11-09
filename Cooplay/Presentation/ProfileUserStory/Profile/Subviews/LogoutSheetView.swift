//
//  LogoutSheetView.swift
//  Cooplay
//
//  Created by Alexandr on 08.11.2023.
//  Copyright © 2023 Ovchinnikov. All rights reserved.
//

import SwiftUI

struct LogoutSheetView : UIViewControllerRepresentable {
    
    @Binding var showAlert: Bool
    let logoutActionHandler: (() -> Void)?

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
         guard context.coordinator.alert == nil && showAlert else { return }
         
         let alert = UIAlertController(
             title: R.string.localizable.profileSettingsLogoutMessage(),
             message: nil,
             preferredStyle: .actionSheet
         )
         context.coordinator.alert = alert
         alert.view.tintColor = R.color.actionAccent()
         let logoutAction = UIAlertAction(
             title: R.string.localizable.profileSettingsLogoutActionButton(),
             style: .default
         ) { _ in
             logoutActionHandler?()
         }
         logoutAction.setValue(R.color.red(), forKey: "titleTextColor")
         let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel(), style: .cancel)
         cancelAction.setValue(R.color.textPrimary(), forKey: "titleTextColor")

         alert.addAction(logoutAction)
         alert.addAction(cancelAction)
         
         DispatchQueue.main.async {
            uiViewController.present(alert, animated: true, completion: {
                self.showAlert = false
                context.coordinator.alert = nil
            })
                         
        }
     }

     func makeUIViewController(context: Context) -> some UIViewController {
         
         return UIViewController()
     }
    
    func makeCoordinator() -> LogoutSheetView.Coordinator {
            Coordinator(self)
    }
    
    final class Coordinator: NSObject {

        var alert: UIAlertController?
        var control: LogoutSheetView
            
        init(_ control: LogoutSheetView) {
            self.control = control
        }
    }
}
