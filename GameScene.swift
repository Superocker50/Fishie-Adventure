//
//  GameScene.swift
//  Fishie Adventure
//
//  Created by Allan Che on 2019-08-16.
//  Copyright © 2019 Allan Che. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

var score = 0
var enemySpawnTimer = NSTimeIntervalSince1970

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = SKSpriteNode(imageNamed: "fishRight")
    var playerSize = CGFloat(0.0)
    
    let scoreLabel = SKLabelNode(fontNamed: "Lato-Medium")



    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let player : UInt32 = 0b1
        static let enemy : UInt32 = 0b10
    }
   
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }

    override func didMove(to view: SKView) {
        score = 0 
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "ocean.")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)

        playerSize = 0.0001*self.size.width

        player.physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRect(x: -player.size.width/2.2, y: -player.size.height/4.8, width: player.size.width/1.2, height: player.size.height/1.55), transform: nil))
    
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.enemy
        
        player.setScale(playerSize)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player.zPosition = 2
        self.addChild(player)
        
        let spawnInterval = random(min: 0.7, max: 0.9)
        
        let wait = SKAction .wait(forDuration: TimeInterval(spawnInterval), withRange: 0.5)
        
        let spawn = SKAction.run({
            self.spawnEnemy()
        })
 
       
        let spawning = SKAction.sequence([wait,spawn])
        run(spawning, withKey: "spawning")
        run(SKAction.repeatForever(spawning), withKey:"spawning")
        
        // Score Text
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 0.05*self.size.width
        scoreLabel.fontColor = SKColor.white
        //scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        //let skView = self.view as! SKView
        view.showsPhysics = true
    }
    
    func addScore(){
        
        if(score < 300){
            score += 5
            scoreLabel.text = "Score: \(score)"
        }

        // Increases the size player as score increases
        if (score < 300) {
            if score % 10 == 0 {
                playerSize += 0.01
                player.setScale(CGFloat(playerSize))
            }
        }
        else{
            gameWon()
        }
    }
    
   
    func spawnEnemy(){
        
        let enemy = SKSpriteNode(imageNamed: "fishLeft")
    
        let randomSize = random(min: 0.00008*self.size.width, max: 0.0003*self.size.width)
        //enemy.size = CGSize(width: randomSize, height: randomSize)

        enemy.setScale(randomSize)
        
        let spawnXLocation = CGFloat(0.0)
        
        let spawnYLocation = random(min: enemy.size.height/2, max: size.height - enemy.size.height/2)
        
        let endPoint = CGPoint(x: spawnXLocation - enemy.size.width, y: spawnYLocation)
        let startPoint = CGPoint(x: spawnXLocation + size.width, y: spawnYLocation)
        
        enemy.position = startPoint
        enemy.zPosition = 3
        
        //enemy.size = CGSize(width: randomSize, height: randomSize)
        
      enemy.physicsBody = SKPhysicsBody(polygonFrom: CGPath(ellipseIn: CGRect(x: -enemy.size.width/2.2, y: -enemy.size.height/4.8, width: enemy.size.width/1.225, height: enemy.size.height/1.9), transform: nil))
       
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.player
        
        self.addChild(enemy)
        print("added enemy")
        
        let speedOfEnemy = random(min: 3.0, max: 5.0)
        let moveEnemy = SKAction.move(to: endPoint, duration: TimeInterval(speedOfEnemy))
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
    }
    
    func playerContactedEnemy(player: SKSpriteNode, enemy: SKSpriteNode){
        // Delete player if player is smaller than enemy, otherwise delete enemy
        
        if(player.size.width > enemy.size.width && player.size.height > enemy.size.height){
            enemy.removeFromParent()
            addScore()
        }
        else{
            player.removeFromParent()
            gameOver()
        }
    }
    
    func gameOver() {
        removeAllChildren()
        removeAllActions()
       
        let sceneAction = SKAction.run(changeSceneGameOver)
        //let delay = SKAction.wait(forDuration: 0.)
        let sequence = SKAction.sequence([sceneAction])
        run(sequence)
        
    }
    
    func gameWon() {
        removeAllChildren()
        removeAllActions()
        
        let sceneAction = SKAction.run(changeSceneGameWon)
        let delay = SKAction.wait(forDuration: 0.3
        )
        let sequence = SKAction.sequence([delay, sceneAction])
        run(sequence)
    }
    
    func changeSceneGameOver() {
        let moveToScene = GameOverScene(size: size)
        moveToScene.scaleMode = scaleMode
        let fade = SKTransition.doorway(withDuration: 1)
        self.view!.presentScene(moveToScene, transition: fade)
    }
    
    func changeSceneGameWon(){
        
        let moveToScene = GameWonScene(size: size)
        moveToScene.scaleMode = scaleMode
        let crossFade = SKTransition.crossFade(withDuration: 1)
        self.view!.presentScene(moveToScene, transition: crossFade)
    }
 
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        playerContactedEnemy(player: nodeA as! SKSpriteNode, enemy: nodeB as! SKSpriteNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //spawnEnemy()
      
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
            
            // Change direction of the player
           if(amountDraggedX < 0){
                player.texture = SKTexture(imageNamed: "fishLeft")
           }
           else{
               player.texture = SKTexture(imageNamed: "fishRight")
           }
            
            player.position.x += amountDraggedX
            player.position.y += amountDraggedY
            
            // Makes sure that the player does not go off screen
            if(player.position.x - player.size.width/2 < 0){
                player.position.x = 0 + player.size.width/2
            }
            if(player.position.x + player.size.width/2 > size.width){
                player.position.x = size.width - player.size.width/2
            }
            if(player.position.y - player.size.width/2 < 0){
                player.position.y = 0 + player.size.height/2
            }
            if(player.position.y + player.size.width/2 > size.height){
                player.position.y = size.height - player.size.height/2
            }
            
        }
    }
    
}

