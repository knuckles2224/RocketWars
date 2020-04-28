//
//  GameScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/19/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import SpriteKit
import GameplayKit

var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum gameState{
        case mainScreen //before starting the game
        case inGame //during the game
        case endScreen //after the game
    }//end enum gameState
    
    let tapToBeginLabel = SKLabelNode(fontNamed: "The Bold Font") //adding a label for player to tap to begin game
    
    var frameTime: TimeInterval = 0 //stores time inbtween each frame that passes
    var deltaFrameTime: TimeInterval = 0
    var animateBackGroundFrame: CGFloat = 600.0 //background moves x points down the screen per second
    
    
    var currentGameState = gameState.mainScreen //default state for now
    
    var gameLevel = 0 //keeps track of what level we are on
    
    var gameLives = 9 //the starting number of lives
    
    let gameLivesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font") //set up the label for score
    
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
        
        gameScore = 0 //reinitialize score everytime we move back to gameScene
        
        self.physicsWorld.contactDelegate = self// set up the physic contacts for the scene
        
        //set up 2background image
        for i in 0...1 {
            let backGround = SKSpriteNode(imageNamed: "earth") //image name can be found in assets
            backGround.size = self.size //set bg to scene size
            backGround.anchorPoint = CGPoint(x: 0.5, y: 0) //anchor point is bottom center of screen now
            backGround.position = CGPoint(x: self.size.width/2, y: self.size.height * CGFloat(i)) //image in bottom of screen and regular size screen
            backGround.zPosition = 0 // background gets lowest number for layering
            backGround.name = "Background"
            self.addChild(backGround) //add background to scene
        }//end for making 2 backgrounds
        //set up player/rocket
        player.setScale(0.75) //scales the image
        player.position = CGPoint(x: self.size.width/2, y: 0 - player.size.height) //start in middle screen, and at bottom of the screen
        player.zPosition = 2 // 2 postion in front of background
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) //give the rocket a "physics body"
        player.physicsBody!.affectedByGravity = false //turn off the gravity for our player object
        //set up struct category for player now
        player.physicsBody!.categoryBitMask = PhysicsGrouping.Player
        player.physicsBody!.collisionBitMask = PhysicsGrouping.None
        player.physicsBody!.contactTestBitMask = PhysicsGrouping.Enemy //physics group for when enemy hits player
        self.addChild(player) //add rocket image to scene
        
        //graphical information on the gameScore label
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 80
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height + scoreLabel.frame.size.height) //position the label on the gamescene
        scoreLabel.zPosition = 10 //make label layer on top of everything
        self.addChild(scoreLabel)
        
        //graphical information on the gameLivesLabel
        gameLivesLabel.text = "Lives: \(gameLives)"
        gameLivesLabel.fontSize = 80
        gameLivesLabel.fontColor = SKColor.white
        gameLivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        gameLivesLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height + gameLivesLabel.frame.size.height)
        gameLivesLabel.zPosition = 10
        self.addChild(gameLivesLabel) //add the gameelivesLbael to the gameScene
        
        let scrollsOntoScreen = SKAction.moveTo(y: self.size.height * 0.90, duration: 0.3) //Drags the lives and score onto the screen
        scoreLabel.run(scrollsOntoScreen)
        gameLivesLabel.run(scrollsOntoScreen)
        
        
        tapToBeginLabel.text = "Tap to Begin"
        tapToBeginLabel.fontSize = 100
        tapToBeginLabel.fontColor = SKColor.white
        tapToBeginLabel.zPosition = 1
        tapToBeginLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        tapToBeginLabel.alpha = 0 //0 trasparency is completely see through
        self.addChild(tapToBeginLabel)
        
        let fadeInView = SKAction.fadeIn(withDuration: 0.4)
        tapToBeginLabel.run(fadeInView)
        
        //startNewLevel() //start level call
    }//end didMove to view
    
    //this function runs every frame that passes in a game
    override func update(_ currentTime: TimeInterval) {
        //calculate time passed in between each frame
        if frameTime == 0 {
            //frame 0
            frameTime = currentTime
        } else {
            deltaFrameTime = currentTime - frameTime
            frameTime = currentTime
        }
        
        let amountToMoveBackGround = animateBackGroundFrame * CGFloat(deltaFrameTime) //calculate the time passed and frame to move background
        
        self.enumerateChildNodes(withName: "Background") { //generate a list with anything named "Background"
            background, stop in
            background.position.y -= amountToMoveBackGround
            if background.position.y < -self.size.height { //if background scrolled to bottom of screen
                background.position.y += self.size.height * 2 //*2 to move to top of screen
            }
        }
        //adjust the 2 backgrounds by variable above
        
    }//end update()
    
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
            
            gameOver() //call to func named gameOver() after collision with enemy
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
    
    func startNewGame() {
        // pregame state -> in game state
        currentGameState = gameState.inGame
        
        //animation to fade the tap to begin label
        let fadeOutTapToStart = SKAction.fadeIn(withDuration: 0.5)
        let deleteTapToStart = SKAction.removeFromParent()
        let deleteTapToStartSequence = SKAction.sequence([fadeOutTapToStart, deleteTapToStart])
        tapToBeginLabel.run(deleteTapToStartSequence)
        
        let moveShipToScreen = SKAction.moveTo(y: self.size.height * 0.20, duration: 0.5)
        let startLevel = SKAction.run(startNewLevel)
        let startGameSequence = SKAction.sequence([moveShipToScreen,startLevel])
        player.run(startGameSequence)
        
    }//end startNewGame
    
    //function firebullet gets called whem player taps screen, it will animate a shooting bullet from the player position going up the screen.
    func fireBullet() {
        //add bullet image to scene
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet" //the reference name to the object
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
        enemy.name = "Enemy" //the node's reference name to be used in game over
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
        let loseLife = SKAction.run(decrementGameLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseLife])
        
        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }
        //get difference of start and endpoints of enemy to rotate ship correctly
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
        
        
    }//end makeEnemy
    
    //this runs when someone clicks or taps on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //if pregame
        if currentGameState == gameState.mainScreen {
            startNewGame()
        }
        //only fires bullet if in Game
        else if currentGameState == gameState.inGame {
            fireBullet() //method call to fireBullet()
        }//end if gameState == inGame
    }//end fireBullet()
    
    //this runs when a player slides their fingers causing an event change
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
         
            let pointofTouch = touch.location(in: self)
            
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let movement = pointofTouch.x - previousPointOfTouch.x //calculate the origin of touch and whre last touch is
            
            //only update movement if gameState is active
            if currentGameState == gameState.inGame {
            player.position.x = player.position.x + movement //update the rocket with current rocket position and however far you moved
            }//end if currentGameState == inGame
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
    
    func decrementGameLife() {
        gameLives = gameLives - 1
        gameLivesLabel.text = "Lives: \(gameLives)"
        
        //flash lives to the screen
        let enhanceLivesText = SKAction.scale(to: 1.5, duration: 0.20)
        let normalizeLivesText = SKAction.scale(to: 1.0, duration: 0.20)
        let flashLivesLabel = SKAction.sequence([enhanceLivesText,normalizeLivesText])
        gameLivesLabel.run(flashLivesLabel)
        
        if gameLives == 0 { //check if lives is 0
            gameOver()
        }//end if lives = 0
    }
    
    func gameOver() {
        //game over is enemy makes contact with player || game over if lives = 0
        
        currentGameState = gameState.endScreen //change the game state when entering gameOver()
        
        //change to game over scene and stop the game scene
        self.removeAllActions()
        
            //freezes enemies on screen
        self.enumerateChildNodes(withName: "Bullet") { //Generates a list of all objects with reference name
            bullet, stop in //Cycle through the list
            bullet.removeAllActions() //remove all the bullets in the list
        }
        
        //freezes all live bullets
        self.enumerateChildNodes(withName: "Enemy") { //Generate the list of enemies on GameSsene
            enemy, stop in
            enemy.removeAllActions()
        }
        
        
        let changeSceneAction = SKAction.run(changeScene)  //calls func named changeScene
        let waitToChangeScene = SKAction.wait(forDuration: 1) //waits for x amount of second
        let changeSceneSequene = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequene)
    }//end gameOver
    
    func changeScene() {
        let switchScenes = GameOverScene(size: self.size) //moves to the gameOverScene with same size
        switchScenes.scaleMode = self.scaleMode //scales the size
        let transitionScene = SKTransition.fade(withDuration: 1.0) //trasitions the Scene
        self.view!.presentScene(switchScenes, transition: transitionScene) //gets rid off current scene and switch to GameOverScene
        
        
    }//end changeScene
}//end class GameScene
