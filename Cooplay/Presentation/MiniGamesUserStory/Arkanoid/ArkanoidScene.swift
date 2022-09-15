//
//  ArkanoidScene.swift
//  Cooplay
//
//  Created by Alexandr on 03.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class ArkanoidScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnPaddle = false
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
      WaitingForTap(scene: self),
      Playing(scene: self),
      GameOver(scene: self)
    ])
    
    var gameWon : Bool = false {
        didSet {
            let gameOver = childNode(withName: Constants.Name.gameMessage) as! SKLabelNode
            gameOver.attributedText = gameWon
            ? Constants.AttributtedText.winMessage
            : Constants.AttributtedText.loseMessage
            let actionSequence = SKAction.sequence([
                SKAction.scale(to: 1.0, duration: 0.25)
            ])
          
        gameOver.run(actionSequence)
      }
    }
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)
  
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let ball = childNode(withName: Constants.Name.ball) as! SKSpriteNode
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let paddle = childNode(withName: Constants.Name.paddle) as! SKSpriteNode
        
        bottom.physicsBody!.categoryBitMask = Constants.Mask.bottom
        ball.physicsBody!.categoryBitMask = Constants.Mask.ball
        paddle.physicsBody!.categoryBitMask = Constants.Mask.paddle
        borderBody.categoryBitMask = Constants.Mask.border
        
        ball.physicsBody!.contactTestBitMask = Constants.Mask.bottom | Constants.Mask.block | Constants.Mask.paddle
        
        enumerateChildNodes(withName: Constants.Name.block) { node, _ in
            node.physicsBody!.categoryBitMask = Constants.Mask.block
        }
        
        let gameMessage = SKLabelNode()
        gameMessage.attributedText = Constants.AttributtedText.startMessage
        //gameMessage.fontColor = R.color.textPrimary()
        //gameMessage.fontSize = 50
        gameMessage.name = Constants.Name.gameMessage
        gameMessage.position = CGPoint(x: frame.midX, y: frame.midY)
        gameMessage.zPosition = 4
        gameMessage.setScale(0.0)
        addChild(gameMessage)
            
        generator.prepare()
        gameState.enter(WaitingForTap.self)
  }
    
    override func update(_ currentTime: TimeInterval) {
        gameState.update(deltaTime: currentTime)
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState.currentState {
            case is WaitingForTap:
                gameState.enter(Playing.self)
                isFingerOnPaddle = true
            case is Playing:
                let touch = touches.first
                let touchLocation = touch!.location(in: self)
                
                if let body = physicsWorld.body(at: touchLocation) {
                    if body.node!.name == Constants.Name.paddle {
                        isFingerOnPaddle = true
                    }
                }
        case is GameOver:
            let newScene = ArkanoidScene(fileNamed:"ArkanoidScene")
            newScene!.scaleMode = .aspectFill
            let reveal = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(newScene!, transition: reveal)
        default:
            break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnPaddle {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            let paddle = childNode(withName: Constants.Name.paddle) as! SKSpriteNode
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
      }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameState.currentState is Playing {
            var firstBody: SKPhysicsBody
            var secondBody: SKPhysicsBody
            if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
                firstBody = contact.bodyA
                secondBody = contact.bodyB
            } else {
                firstBody = contact.bodyB
                secondBody = contact.bodyA
            }
            if firstBody.categoryBitMask == Constants.Mask.ball && secondBody.categoryBitMask == Constants.Mask.bottom {
                generator.impactOccurred()
                gameState.enter(GameOver.self)
                gameWon = false
            }
            if firstBody.categoryBitMask == Constants.Mask.ball && secondBody.categoryBitMask == Constants.Mask.paddle {
                generator.impactOccurred()
            }
            if firstBody.categoryBitMask == Constants.Mask.ball && secondBody.categoryBitMask == Constants.Mask.block {
                breakBlock(node: secondBody.node!)
                if isGameWon() {
                    gameState.enter(GameOver.self)
                    gameWon = true
                }
            }
        }
    }
    
    func breakBlock(node: SKNode) {
        let particles = SKEmitterNode(fileNamed: Constants.Name.brokenPlatform)!
      particles.position = node.position
      particles.zPosition = 3
      addChild(particles)
      particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
        SKAction.removeFromParent()]))
      node.removeFromParent()
        generator.impactOccurred()
    }
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        self.enumerateChildNodes(withName: Constants.Name.block) { node, stop in
            numberOfBricks = numberOfBricks + 1
        }
      return numberOfBricks == 0
    }
    
}


// MARK: - Constants

private enum Constants {
    
    enum Name {
        
        static let ball = "ball"
        static let paddle = "paddle"
        static let block = "block"
        static let gameMessage = "gameMessage"
        static let brokenPlatform = "BrokenPlatform"
    }
    
    enum Mask {
        
        static let ball   : UInt32 = 0x1 << 0
        static let bottom : UInt32 = 0x1 << 1
        static let block  : UInt32 = 0x1 << 2
        static let paddle : UInt32 = 0x1 << 3
        static let border : UInt32 = 0x1 << 4
    }
    
    enum Text {
        
        static let startMessage = R.string.localizable.arkanoidStartMessage()
        static var winMessage: String {
            NSLocalizedString(
                "arkanoid.win.\(Int.random(in: 0...4)).message",
                tableName: R.string.localizable.tableName(),
                comment: ""
            )
        }
        static var loseMessage: String {
            NSLocalizedString(
                "arkanoid.lose.\(Int.random(in: 0...4)).message",
                tableName: R.string.localizable.tableName(),
                comment: ""
            )
        }
    }
    
    enum Font {
        
        static let message = UIFont.systemFont(ofSize: 50, weight: .regular)
    }
    
    enum Color {
        
        static let message = R.color.textPrimary()!
    }
    
    enum AttributtedText {
        
        static var startMessage: NSAttributedString {
            NSAttributedString(
                string: Text.startMessage,
                attributes: [
                    .font: Font.message,
                    .foregroundColor: Color.message
                ]
            )
        }
        static var winMessage: NSAttributedString {
            NSAttributedString(
                string: Text.winMessage,
                attributes: [
                    .font: Font.message,
                    .foregroundColor: Color.message
                ]
            )
        }
        static var loseMessage: NSAttributedString {
            NSAttributedString(
                string: Text.loseMessage,
                attributes: [
                    .font: Font.message,
                    .foregroundColor: Color.message
                ]
            )
        }
    }
}
