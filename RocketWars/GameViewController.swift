//
//  GameViewController.swift
//  RocketWars
//
//  Created by Anthony Onn on 4/19/20.
//  Copyright © 2020 Anthony Onn. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation //code for adding audio

class GameViewController: UIViewController {
    
    var backgroundMusic = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tell the AVAudioPlayer to player song
        let filePath = Bundle.main.path(forResource: "SongMidnight", ofType: "mp3") //type in the track name here
        let songAudio = NSURL(fileURLWithPath: filePath!) //pass the audio path
        
        //try to play the music
        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: songAudio as URL)
        } catch {
            return print("audio missing")
        }// end do catch
        
        //loops the song
        backgroundMusic.numberOfLoops = -1 //loops forever with negtive number
        backgroundMusic.play()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
             let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048)) //scales the gameScen to fit device
            //if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            //}//end if let scene
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }//end if let view
    }//end viewDidLoad

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
