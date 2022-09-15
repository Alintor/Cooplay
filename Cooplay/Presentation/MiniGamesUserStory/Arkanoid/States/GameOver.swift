//
//  GameOver.swift
//  Cooplay
//
//  Created by Alexandr on 03.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: ArkanoidScene
  
    init(scene: SKScene) {
        self.scene = scene as! ArkanoidScene
        super.init()
    }
  
    override func didEnter(from previousState: GKState?) {
        if previousState is Playing {
            let ball = scene.childNode(withName: Constants.Name.ball) as! SKSpriteNode
            ball.physicsBody!.linearDamping = 1.0
            scene.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        }
  }
  
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }

}

// MARK: - Constants

private enum Constants {
    
    enum Name {
        
        static let ball = "ball"
    }
}
