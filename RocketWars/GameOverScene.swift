//
//  GameOverScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/27/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    let restartButton = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        //needs a background
        let backGround = SKSpriteNode(imageNamed: "stars") //image name can be found in assets
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        //needs LABEL:  game over, score , high score , restart with BUTTON
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score \(gameScore)"
        scoreLabel.fontSize = 150
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.60)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let gameDefault = UserDefaults() //records the highscore
        var highScore = gameDefault.integer(forKey: "highScoreSaved") //save an int with the key
        
        //check for new high score
        if gameScore > highScore {
            highScore = gameScore //update high score
            gameDefault.set(highScore, forKey: "highScoreSaved") //sets the new high score using the key
        }//end gamescore > highscore
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 150
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        self.addChild(highScoreLabel)
        
        //add the label button
        restartButton.text = "Restart"
        restartButton.fontSize = 100
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 1
        restartButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.30) //hald screen, 30% up
        self.addChild(restartButton)
    }//end didMove
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let pointTouching = touch.location(in: self)
            //if location touch matches the button
            if restartButton.contains(pointTouching) {
                //Takes back into the gameScene
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}//end GameOverScene
