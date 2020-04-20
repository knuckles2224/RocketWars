//
//  GameScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/19/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //Gloabal vars
    let player = SKSpriteNode(imageNamed: "rockShip") //adds the rocket ship image, initialized outside of scope
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsoundeffect.wav", waitForCompletion: false) //adds the sound effect noise for bullet sounds when shooting
    
    let gameArea: CGRect
    
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
        self.addChild(player) //add rocket image to scene
        
        startNewLevel() //start level call
    }//end didMove to view
    
    func startNewLevel() {
        //actions to spawn enemy
        let spawn = SKAction.run(spawnEnemy)
        
        //gap between enemy spawning
        let waitToSpawn = SKAction.wait(forDuration: 1)
        
        //call the sequence and let run in that order
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        
        //keep spawning enemies
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        //run action on the scene
        self.run(spawnForever)
        
        
        
    }//end startNewLevel()
    //function firebullet gets called whem player taps screen, it will animate a shooting bullet from the player position going up the screen.
    func fireBullet() {
        //add bullet image to scene
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position //bullet will shoot where player rocket is
        bullet.zPosition = 1 //inbetween background and rocket
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
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        self.addChild(enemy)
        
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
    
}//end class GameScene
