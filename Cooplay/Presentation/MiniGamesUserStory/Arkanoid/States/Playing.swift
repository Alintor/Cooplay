//
//  Playing.swift
//  Cooplay
//
//  Created by Alexandr on 03.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class Playing: GKState {
    unowned let scene: ArkanoidScene
  
    init(scene: SKScene) {
        self.scene = scene as! ArkanoidScene
        super.init()
    }
  
    override func didEnter(from previousState: GKState?) {
        if previousState is WaitingForTap {
            let ball = scene.childNode(withName: Constants.Name.ball) as! SKSpriteNode
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: randomDirection()))
        }
    }
  
    override func update(deltaTime seconds: TimeInterval) {
        let ball = scene.childNode(withName: Constants.Name.ball) as! SKSpriteNode
        let maxSpeed: CGFloat = 1800
          
        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
          
        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
        if xSpeed < 400.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
        }
        if ySpeed < 400.0 {
            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
        }
        if speed > maxSpeed {
            ball.physicsBody!.linearDamping = 0.4
        } else {
            ball.physicsBody!.linearDamping = 0.0
        }
  }
  
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameOver.Type
    }
    
    func randomDirection() -> CGFloat {
        let speedFactor: CGFloat = 100.0
//        if scene.randomFloat(from: 0.0, to: 100.0) >= 50 {
//            return -speedFactor
//        } else {
//            return speedFactor
//        }
        
        return Bool.random() ? speedFactor : -speedFactor
    }

}

// MARK: - Constants

private enum Constants {
    
    enum Name {
        
        static let ball = "ball"
    }
}
