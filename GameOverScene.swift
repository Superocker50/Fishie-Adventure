//
//  GameOverScene.swift
//  Fishie Adventure
//
//  Created by Allan Che on 2019-09-27.
//  Copyright © 2019 Allan Che. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "ocean.")
        background.alpha = 0.2
        background.size = size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 0
        addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Lato-Medium")
        gameOverLabel.text = "You've been eaten! Yikes!"
        gameOverLabel.fontSize = 0.05*self.size.width
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.7)
        gameOverLabel.zPosition = 1
        addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Lato-Medium")
        scoreLabel.text = "Your Score Was: \(score)"
        scoreLabel.fontSize = 0.05*self.size.width
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: size.width/2, y: self.size.height*0.55)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        let restartButton = SKLabelNode(fontNamed: "Lato-Medium")
        restartButton.text = "Tap to Restart"
        restartButton.fontSize = 0.05*self.size.width
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 2
        restartButton.position = CGPoint(x: size.width/2, y: size.height*0.3)
        addChild(restartButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _: AnyObject in touches{
            
            let restartScene = GameScene(size: size)
            restartScene.scaleMode = scaleMode
            let horizontalTransition = SKTransition.doorsOpenHorizontal(withDuration: 1
            )
            self.view?.presentScene(restartScene, transition: horizontalTransition)
        }
    }
}
