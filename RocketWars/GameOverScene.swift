//
//  GameOverScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/27/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import Foundation
import SpriteKit

//This class acts as the Game Over Scene when player loses all lives or dies
class GameOverScene: SKScene {
    
    //add "Restart" label to the GameOverScene
    let restartButton = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        //Setup and add a background for while in the GameOverScene
        let backGround = SKSpriteNode(imageNamed: "stars") //image name can be found in assets
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        //edit the "Restart" label
        restartButton.text = "Restart"
        restartButton.fontSize = 100
        restartButton.fontColor = SKColor.white
        restartButton.zPosition = 1
        restartButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.30) //half screen, 30% up
        self.addChild(restartButton)
        
        //add "GAMER OVER" label to the GameOverScene
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 200
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        //add the "Dodge" label to the GameOverScene
        let dodgeLabel = SKLabelNode(fontNamed: "The Bold Font")
        dodgeLabel.text = "Dodge: \(gameLives)" //present the current score for that instance of the gameplay
        dodgeLabel.fontSize = 150
        dodgeLabel.fontColor = SKColor.white
        dodgeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.60)
        dodgeLabel.zPosition = 1
        self.addChild(dodgeLabel)
        
        //add the "Destroy" label to the GameOverScene
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Destroy: \(gameScore)" //present the current score for that instance of the gameplay
        scoreLabel.fontSize = 150
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.50)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        //UserDefaults uses storage memory to keep data, used to keep record for highscore.
        let gameDefault = UserDefaults() //records the highscore
        var highScore = gameDefault.integer(forKey: "highScoreSaved") //save an int with the key
        
        //check for new high score
        if gameLives > highScore {
            highScore = gameLives //update high score
            gameDefault.set(highScore, forKey: "highScoreSaved") //sets the new high score using the key
        }//end gamescore > highscore
        
        //add the "high Score" label to the GameOverScene
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScore)"
        highScoreLabel.fontSize = 150
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.zPosition = 1
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.40)
        self.addChild(highScoreLabel)
    }//end didMove
    
    //This function, while in the GameOverScene, scans and checks if the user touches the area where the "Restart" text is on the screen, if so, switch over to the GameScene.
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
            }//end if restartButton.contains
        }//end for touch: in touches
    }//end touchesBegan
}//end GameOverScene
