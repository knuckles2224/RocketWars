//
//  MainMenuScene.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/28/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import Foundation
import SpriteKit //turns the class into a scene

class MainMenuScene: SKScene{
    //makes the main menu in the scene
    override func didMove(to view: SKView) {
        //set up the background for the main menu scene
        let backGround = SKSpriteNode(imageNamed: "stars")
        backGround.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backGround.zPosition = 0
        self.addChild(backGround) //add the backGround to the scene
        
        //set up author name title in main menu
        let author = SKLabelNode(fontNamed: "The Bold Font")
        author.text = "By: Rathanak A. Onn"
        author.fontSize = 50
        author.fontColor = SKColor.white
        author.position = CGPoint(x: self.size.width * 0.345, y: self.size.height * 0.75)
        author.zPosition = 1 //put it above the backGround's zPosition
        self.addChild(author) //add to the MainMenuScene
        
        //set up the Title for the MainMenuScene
        let gameTitle = SKLabelNode(fontNamed: "The Bold Font")
        gameTitle.text = "Rocket Wars"
        gameTitle.fontSize = 150
        gameTitle.fontColor = SKColor.white
        gameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.65)
        gameTitle.zPosition = 1
        self.addChild(gameTitle)
        
        //set up the start game title
        let startGameTitle = SKLabelNode(fontNamed: "The Bold Font")
        startGameTitle.text = "Start New Game"
        startGameTitle.fontSize = 85
        startGameTitle.fontColor = SKColor.white
        startGameTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        startGameTitle.zPosition = 1
        self.addChild(startGameTitle)
        
        
    }//end didMove
}//end MainMenuScene
