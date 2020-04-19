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
    
    let player = SKSpriteNode(imageNamed: "rockShip")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsoundeffect.wav", waitForCompletion: false)
    
    //this function runs as soon as scene loads up
    override func didMove(to view: SKView) {
        
        //set up image
        let backGround = SKSpriteNode(imageNamed: "earth")
        backGround.size = self.size //set bg to scene size
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2) //image in center of scene
        backGround.zPosition = 0 // background gets lowest number
        
        self.addChild(backGround) //add bg
        
        //set up player/rocket
        player.setScale(0.75) //scales the image
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2 // 2 postion in front of background
        
        self.addChild(player)
    }//end didMove to view
    
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound,moveBullet,deleteBullet])
        bullet.run(bulletSequence)
        
    }//end fireBullet
    
    //this runs when someone clicks or taps on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }//end fireBullet()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointofTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let movement = pointofTouch.x - previousPointOfTouch.x
            
            player.position.x = player.position.x + movement
        }
    }//end touchesMoved
    
}//end class GameScene
