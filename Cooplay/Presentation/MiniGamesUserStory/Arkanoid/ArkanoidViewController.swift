//
//  ArkanoidViewController.swift
//  Cooplay
//
//  Created by Alexandr on 03.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import UIKit
import SpriteKit

class ArkanoidViewController: UIViewController {
    
    private let skView = SKView()
    private let closeButton = UIButton(type: .close)
    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(skView)
        skView.frame = view.safeAreaLayoutGuide.layoutFrame
        if let scene = ArkanoidScene(fileNamed:"ArkanoidScene") {
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
        setupCloseButton()
    }

    override var shouldAutorotate : Bool {
        return false
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    private func setupCloseButton() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.tintColor = R.color.actionAccent()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            ])
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
