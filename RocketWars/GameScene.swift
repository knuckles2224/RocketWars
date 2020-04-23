//
//  GameScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/19/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var gameScore = 0 //var for the game's total score
    
    var gameLevel = 0 //keeps track of what level we are on
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font ") //set up the label for score
    
    //Gloabal vars
    let player = SKSpriteNode(imageNamed: "rockShip") //adds the rocket ship image, initialized outside of scope
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsoundeffect.wav", waitForCompletion: false) //adds the sound effect noise for bullet sounds when shooting
    
    let explosionSound = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    
    let gameArea: CGRect
    
    
    struct PhysicsGrouping {
        //turn off collisions for all objects
        static let None : UInt32 = 0 //0 represents binary for 0
        static let Player : UInt32 = 0b1 //binary for 1
        static let Bullet : UInt32 = 0b10 //binary for 2
        static let Enemy : UInt32 = 0b100 //binary for 4
    }//end struct
    
    //utility functions to generate random numbers for enemy ships
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF) )
    //    return CGFloat.random(in: 0..<1)
    }//end random()
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }//end random(min,max)
    

    
    override init(size: CGSize) {
        //set up gameArea
        let maxAspectRatio: CGFloat = 16.0/9.0
        
        let playableWidth = size.height / maxAspectRatio
        
        let margin = (size.width - playableWidth) / 2 //diff between scene and play area / 2
        
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this function runs as soon as scene loads up
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self// set up the physic contacts for the scene
        
        //set up background image
        let backGround = SKSpriteNode(imageNamed: "earth") //image name can be found in assets
        backGround.size = self.size //set bg to scene size
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2) //image in center of scene
        backGround.zPosition = 0 // background gets lowest number for layering
        self.addChild(backGround) //add background to scene
        
        //set up player/rocket
        player.setScale(0.75) //scales the image
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2) //start in middle screen, but lower in y pos
        player.zPosition = 2 // 2 postion in front of background
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) //give the rocket a "physics body"
        player.physicsBody!.affectedByGravity = false //turn off the gravity for our player object
        //set up struct category for player now
        player.physicsBody!.categoryBitMask = PhysicsGrouping.Player
        player.physicsBody!.collisionBitMask = PhysicsGrouping.None
        player.physicsBody!.contactTestBitMask = PhysicsGrouping.Enemy //physics group for when enemy hits player
        self.addChild(player) //add rocket image to scene
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 80
        scoreLabel.fontColor = SKColor.purple
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.20, y: 0.70) //position the label on the gamescene
        scoreLabel.zPosition = 10 //make label later on top of everything
        self.addChild(scoreLabel)
        
        
        startNewLevel() //start level call
    }//end didMove to view
    
    //function that gets called when 2 bodies make contact with each other
    func didBegin(_ contact: SKPhysicsContact) {
        var contactBody1 = SKPhysicsBody()
        var contactBody2 = SKPhysicsBody()
        
        //use the bit numbers declared in struct to organize the collision body
        //lowest category bit number gets bodyA, higher bitnumber gets bodyB
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactBody1 = contact.bodyA
            contactBody2 = contact.bodyB
        } else {
            contactBody1 = contact.bodyB
            contactBody2 = contact.bodyA
        }
        
        
        //check if the player and the enemy collide
        if contactBody1.categoryBitMask == PhysicsGrouping.Player && contactBody2.categoryBitMask == PhysicsGrouping.Enemy{
            
            if contactBody1.node != nil { //if the object is there, to avoid 2 bullets on 1 object
            spawnExplosion(spawnPosition: contactBody1.node!.position) //pass in the postion of the player
            }
            
            if contactBody2.node != nil {
            spawnExplosion(spawnPosition: contactBody2.node!.position)
            }
            
            contactBody1.node?.removeFromParent()
            contactBody2.node?.removeFromParent()
            
        }//end player and enemy contacts
        
        //check if the bullet made contact with the enemy
        if contactBody1.categoryBitMask  == PhysicsGrouping.Bullet && contactBody2.categoryBitMask == PhysicsGrouping.Enemy {
            
            //first update the score by calling function
            addScore()
            
            if contactBody2.node != nil {
                if contactBody2.node!.position.y > self.size.height {
                    return //do nothing because bullet is out of screen
                } else {
                    spawnExplosion(spawnPosition: contactBody2.node!.position) //only explode the enemy

                }
            }
            contactBody1.node?.removeFromParent()
            contactBody2.node?.removeFromParent()
            
        }//end if bullet and enemy
    }//end didBegin contact
    
    //this function takes in as an argument a CGPoint(2 Dimensional) so when we spawn the image explsion we know where to put it
    func spawnExplosion(spawnPosition: CGPoint) {
        
       
        let explosion = SKSpriteNode(imageNamed: "exploding") //create sprite node for explosion
        explosion.position = spawnPosition // set the postion to the passed in argument
        explosion.zPosition = 3
        
        //set the animation for the explosion
        explosion.setScale(0)
        
        self.addChild(explosion) //add the explosion to the scene
        
        let scaleExplosion = SKAction.scale(to: 1, duration: 0.2)
        let fadeExplosion = SKAction.fadeOut(withDuration: 0.2)
        let deleteExplosion = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleExplosion,fadeExplosion,deleteExplosion])
        
        explosion.run(explosionSequence) //run the sprite node sequence
    }//end spawn explosion
    
    func startNewLevel() {
        
        //incrememnt level everyimte this function is called
        gameLevel = gameLevel + 1
        
        //stop the actions
        if self.action(forKey: "Incoming Enemies") != nil {
            self.removeAction(forKey: "Incoming Enemies")
        }
        
        //set up level difficulty
        var levelDuration = TimeInterval()
        
        switch gameLevel {
        case 1: levelDuration = 1.5
        case 2: levelDuration = 1.25
        case 3: levelDuration = 1.0
        case 4: levelDuration = 0.75
        case 5: levelDuration = 0.50
        default:
            levelDuration = 0.25
            print("more than 5 levels passed")
        }
        //actions to spawn enemy
        let spawn = SKAction.run(spawnEnemy)
        
        //gap between enemy spawning
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        
        //call the sequence and let run in that order
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        
        //keep spawning enemies
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        //run action on the scene with a key reference
        self.run(spawnForever, withKey: "Incoming Enemies")
        
    }//end startNewLevel()
    
    //function firebullet gets called whem player taps screen, it will animate a shooting bullet from the player position going up the screen.
    func fireBullet() {
        //add bullet image to scene
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position //bullet will shoot where player rocket is
        bullet.zPosition = 1 //inbetween background and rocket
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        //set up the grouping struct for bullet
        bullet.physicsBody!.categoryBitMask = PhysicsGrouping.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsGrouping.None //dont want any collisions
        bullet.physicsBody!.contactTestBitMask = PhysicsGrouping.Enemy //will be told when bullet hits enemy
        self.addChild(bullet)
        
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1) //move the bullet upwards
        let deleteBullet = SKAction.removeFromParent() //delete it from scene to reduce lag
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet]) //will do functions in this order
        bullet.run(bulletSequence) //run the sequence above in order
        
    }//end fireBullet
    
    //this function creates an enemy within bounds of the gameArea x values and then makes them move downward
    func spawnEnemy(){
        
        //where enemy can spawn
        let onlyStartAt = random(min: gameArea.minX, max: gameArea.maxX)
        
        //where enemy can end up going to
        let onlyEndAt = random(min: gameArea.minX, max: gameArea.maxX)
        
        //set up 2 CGPoints where enemy can spawn and end
        let startPoint = CGPoint(x: onlyStartAt, y: self.size.height * 1.2) //enemy spawn
        let endPoint = CGPoint(x: onlyEndAt, y: -self.size.height * 0.2)
        
        //spawn actual enemy
        let enemy = SKSpriteNode(imageNamed: "22")
        enemy.setScale(0.75)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        //set up struct physics grouping for emeny
        enemy.physicsBody!.categoryBitMask = PhysicsGrouping.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsGrouping.None
        enemy.physicsBody!.contactTestBitMask = PhysicsGrouping.Player | PhysicsGrouping.Bullet //if enemy hits player or bullet
        self.addChild(enemy) //add the object to scene
        
        //move enemy to a random end point
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
       // let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        //check if bullet hits enemy
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        //get difference of start and endpoints of enemy to rotate ship correctly
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
        
        
    }//end makeEnemy
    
    //this runs when someone clicks or taps on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet() //method call to fireBullet()
        
    }//end fireBullet()
    
    //this runs when a player slides their fingers causing an event change
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
         
            let pointofTouch = touch.location(in: self)
            
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let movement = pointofTouch.x - previousPointOfTouch.x //calculate the origin of touch and whre last touch is
            
            player.position.x = player.position.x + movement //update the rocket with current rocket position and however far you moved
            
            //keep rocket ship in gameArea after moving
            //check if it is too far right
            if player.position.x > gameArea.maxX - player.size.width / 2{
                player.position.x = gameArea.maxX - player.size.width/2 //keep player on right of screen
            }
            
            //check if player is too right left
            if player.position.x < gameArea.minX + player.size.width / 2 {
                player.position.x = gameArea.minX + player.size.width / 2 //keep player on left point of gameArea
            }
        }
    }//end touchesMoved
    
    //this function updates the score label on the gameScene, only gets called when a bulet collides with an enemy.
    func addScore() {
        
        gameScore = gameScore + 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //after adding score, check to see if a cretain amounf of points reached to get to the next level, if you score then, then move to level 2, etc.
        if gameScore == 10 {
            startNewLevel() //call from level 1 to level 2
        }else if  gameScore == 25 {
            startNewLevel() //call from level 2 to level 3
        }else if gameScore == 40 {
            startNewLevel() //call from level 3 to level 4
        }else if gameScore == 75 {
            startNewLevel() //call from level 4 to level 5
        }
        
        
    }//end AddScore
}//end class GameScene
