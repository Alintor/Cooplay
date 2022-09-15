//
//  WaitingForTap.swift
//  Cooplay
//
//  Created by Alexandr on 03.09.2022.
//  Copyright © 2022 Ovchinnikov. All rights reserved.
//

import SpriteKit
import GameplayKit

class WaitingForTap: GKState {
    unowned let scene: ArkanoidScene
  
    init(scene: SKScene) {
        self.scene = scene as! ArkanoidScene
        super.init()
    }
  
    override func didEnter(from previousState: GKState?) {
        let scale = SKAction.scale(to: 1.0, duration: 0.25)
        scene.childNode(withName: Constants.Name.gameMessage)!.run(scale)
    }
  
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let scale = SKAction.scale(to: 0, duration: 0.4)
            scene.childNode(withName: Constants.Name.gameMessage)!.run(scale)
        }
    }
  
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }

}

// MARK: - Constants

private enum Constants {
    
    enum Name {
        
        static let gameMessage = "gameMessage"
    }
}
