# RocketWars

* Introduction:

  This is an application called RocketWars and it is my project that I am going to use for the lab of CIS3513 at Temple University. The overview of this project is that it will be a 2-D based iOS game application. It will be using the Swift programming language and the main function of this application is to run and behave like a working game. This will include things like incorporating images to fit the theme of the game, logic to handle how the game should function, adding sound effects for things when certain action happens, keeping track of lives and etc. My motivation for choosing to do a project like this is because I never done a game appliation before, and I gotten into Computer Science due to my interest for video games, when learning Swift, and the process of mobile development, I really enjoyed Swift as a language. So, since I enjoy Swift, enjoy video games, and always wanted to see how the aspects and logic of games work, why not try one out myself!
  
* Design:

  The design of this application revolves all around 3 SKScenes. 
  * MainMenuScene:
    * The MainMenuScene responsibility is to present SKLabels to the user to show them the title of the game, the author, and an option to press here to play. When the user taps in that area they will be redicrected to the gameScene.
  * GameScene:
    * The GameScene's responsibility, where most of the logic is, will be to handle everything the that runs in the game. So to provide the background, needed text, nodes for the players, nodes for the enemies, and to handle collision and point scoring.
  * GameOverScene:
    * The GameOverScene responsibility is to show when the game is over, when the player and the enemy collide. This scene's responsibility is to show the game over label, the amount of enemies you destroyed and dodged, and an option to restart, which will load you back into the gameScene.
* Testing:
  
  While writing each line of code, I run the application to see and try to test if anything has changed from the previous state from when I last tested the code. That way I can see and check step by step that each line of code is doing what it should do and interacting with what it should interact with. I tested things like moving the character off screen, and shooting, to which the sound effect of a bullet firing could be heard even when off screen, so I added lines of code to keep the player object within the GameScene. Testing logic of the code as it is written.
  
  Also keeping the display nodes to be true, so I can keep track of how many nodes are on any Scene at a given time.
  
* Challenges:
  
  First time writing a game application ever! That's why I wanted to make something just 2-dimensional, to get an understanding of how an arcade base game may be developed. The challenges were figuring out a good structure of the code, that way when you even need to go back and add a feature, it will be easy to change without breaking the entire code.
  
  Figuring out the math needed to calculate where nodes should be, how to calculate tracjectory, keeping track of points.
  
* Remarks:
  
  This was really fun to make!
  
  My resource for studying and learning this game developing was based of this tutorial from Youtube. Goes in depth and explains why things should be a certain way.
  
  All code in this project was written by me.
  
  https://www.youtube.com/playlist?list=PLrL5aCF7Ods-6C7QjzXibUZoYjMzhWBfL
  
  <img src="https://github.com/knuckles2224/RocketWars/blob/master/Screen%20Shot%202020-04-29%20at%204.56.27%20PM.png" width="240">
  
  <img src="https://github.com/knuckles2224/RocketWars/blob/master/Screen%20Shot%202020-04-29%20at%204.56.52%20PM.png" width="240">
   
  <img src="https://github.com/knuckles2224/RocketWars/blob/master/Screen%20Shot%202020-04-29%20at%204.57.07%20PM.png" width="250">
  
  <img src="https://github.com/knuckles2224/RocketWars/blob/master/Screen%20Shot%202020-04-29%20at%205.39.14%20PM.png" width="250">
