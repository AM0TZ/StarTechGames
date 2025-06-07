// Ninja Game by Amotz Holender-Tal ©2025

// Example game for StarTech students showcasing advanced features:
//  * Dash action triggered by double-tapping a movement key
//  * Ultimate (ULT) attack with custom animation and a chargeable Ult bar
//  * Hidden God Mode activated by a special key sequence (causes a shuriken explosion)
//  * High score system with persistent storage using a .txt file
//  * Level-based difficulty progression
//  * Toggle background music on/off
//  * Multiple sprite animations: ninja, shuriken, explosion, lightning, and slash effects
//  * Includes opening screen, game over screen, and high score display

// initializing objects

Image background1 = new Image();
Image background2 = new Image();
Image background3 = new Image();
Image startGame = new Image();
Image boom = new Image();
Image highScoreScreen = new Image();
Image gameOverScreen = new Image();
Music GameRun = new Music();
Music success = new Music();
Music failed = new Music();
Music youlose = new Music();
Music victory = new Music();
Music ExplosionFX = new Music();
Text scoretxt = new Text();
Text highScoretxt = new Text();
Text currentScoretxt = new Text();
Text leveltxt = new Text();
Text controltxt = new Text();
Text restart = new Text();
Text Menutxt = new Text();
SpriteSheet ninja = new SpriteSheet();
SpriteSheet shuriken = new SpriteSheet();
SpriteSheet slash = new SpriteSheet();
SpriteSheet ManaFull = new SpriteSheet();
SpriteSheet Explosion = new SpriteSheet();
SpriteSheet Lightning = new SpriteSheet();

//initializing variables:

int level = 1;
int score = 0;
int musicOn = 0;
boolean GameOn = false; // game states: 0=menus, 1=game running
boolean EndMessagePlayed = false; // call message only once
int slashtimer = 0; // slash animation timer
//double-tap 
int lastPressTime = 0; //double tap logic:
int doubleTapThreshold = 300; // 300 milliseconds
// heart array:
int lives = 10;
PImage[] livesImages;
float[] livesX;
float[] livesY;
float livesWidth = 50;
float livesHeight = 50;
// Mana bar:
PImage[] Mana;
int UltTimer = 0;
// ULT sprites:
int ExplosionTimer = 0;
int lightning_origin;
//god mode 
char[] lastKeys = new char[3];
boolean godmode = false;
//highscore 
int highScore = 0;
boolean highScoreSaved = false;
String playerName = "Player1"; 
boolean enteringName = false;
boolean nameEntered = false;
// music control
  
// game setup (runs only once at initialization phase)

void setup() {
  size(1024, 512);
  background1.setImage("bg 1.png");  // game backgrounds:
  background1.x = 0;
  background1.y = 0;
  background1.width = 1024;
  background1.height = 512;

  background2.setImage("bg 2.png"); 
  background2.x = 0;
  background2.y = 0;
  background2.width = 1024;
  background2.height = 512;
  
  background3.setImage("bg 3.png");  
  background3.x = 0;
  background3.y = 0;
  background3.width = 1024;
  background3.height = 512;

  highScoreScreen.setImage("highScore.png");  // win screen
  highScoreScreen.x=0;
  highScoreScreen.y =0;
  highScoreScreen.width = 1024;
  highScoreScreen.height = 512;

  gameOverScreen.setImage("game over.png");  //defet screen
  gameOverScreen.x=0;
  gameOverScreen.y =0;
  gameOverScreen.width = 1024;
  gameOverScreen.height = 512;

  startGame.setImage("start.png");   //start screen
  startGame.x=0;
  startGame.y =0;
  startGame.width = 1024;
  startGame.height = 512;

  shuriken.imageBaseName = "shurikenA_";  // ninja animation
  shuriken.NumOfImage = 4;
  shuriken.animationFactor = 3;
  shuriken.x = (int)random(974);
  shuriken.y = 1;
  shuriken.width = 50;
  shuriken.height = 50;
  shuriken.direction = Direction.DOWN;
  shuriken.speed = 5;
  
  Explosion.imageBaseName = "explosion-f";  // ULT explosion animation
  Explosion.NumOfImage = 8;
  Explosion.animationFactor = 3;
  Explosion.width = 100;
  Explosion.height = 100;
  Explosion.x = shuriken.x;
  Explosion.y = shuriken.y;
  
  Lightning.imageBaseName = "lightning";  // ULT lightning animation
  Lightning.NumOfImage = 7;
  Lightning.animationFactor = 3;
  Lightning.width = 225;
  Lightning.height = 512;
  Lightning.x = shuriken.x;
  Lightning.y = shuriken.y;
  
  ManaFull.imageBaseName = "Ult_full";  // FULL Mana bar animation
  ManaFull.NumOfImage = 4;
  ManaFull.animationFactor = 10;
  ManaFull.x = 490;
  ManaFull.y = 60;
  ManaFull.width = 80;
  ManaFull.height = 30;
     
  slash.imageBaseName = "Slash3_color4_frame"; // ninja slash FX anumation
  slash.NumOfImage = 9;
  slash.animationFactor = 2;
  slash.x = 512;
  slash.y = 412;
  slash.width = 100;
  slash.height = 100;
  
  ninja.imageBaseName = "ninja";  // ninja object
  ninja.NumOfImage = 4;
  ninja.animationFactor = 10;
  ninja.x = 512;
  ninja.y = 412;
  ninja.width = 100;
  ninja.height = 100;
  
  lives = 5;    // Lives 
  createLivesArray(); 
  
  createBarArray(); // Mana Bar
  
// sound FX loading into objects

  youlose.load("youlose.mp3");  
  victory.load("victory.mp3");
  success.load("haya2.mp3");
  failed.load("fail.mp3");
  ExplosionFX.load("Explosion.mp3");
  GameRun.load("bg_music.mp3"); //background music looping:
  GameRun.loop = true;
  GameRun.play();

  
// text objects defenitions:

  textAlign(CENTER, CENTER);

  scoretxt.x = 80;  //Score
  scoretxt.y = 30;
  scoretxt.brush = color(255);
  scoretxt.textSize = 36;
  scoretxt.font = "Tahoma";

  String[] data = loadStrings("highScore.txt"); // Load file content
  if (data != null && data.length > 0) {
    String[] parts = split(data[0], ','); // Split name and score
    if (parts.length == 2) {
      playerName = parts[0];
      highScore = int(parts[1]);
      }    
    }  else {
    highScore = -1;
    }
  highScoretxt.x = 510; //Score
  highScoretxt.y = 100;
  highScoretxt.brush = color(255);
  highScoretxt.textSize = 20;
  highScoretxt.font = "Tahoma";
  highScoretxt.text = "High Score: "  + str(highScore) + " | Player: " + playerName;

  currentScoretxt.x = 510; //Score
  currentScoretxt.y = 100;
  currentScoretxt.brush = color(255);
  currentScoretxt.textSize = 20;
  currentScoretxt.font = "Tahoma";
  currentScoretxt.text = "your Score: " + str(score);

  leveltxt.x = 530;  //Level
  leveltxt.y = 35;
  leveltxt.brush = color(255);
  leveltxt.textSize = 36;
  leveltxt.font = "Tahoma";
  leveltxt.text = "Level " + level;

  controltxt.x = 900; //on screen Controls menu
  controltxt.y = 440;
  controltxt.brush = color(255);
  controltxt.textSize = 16;
  controltxt.font = "Tahoma";
  controltxt.text = "<-- LEFT | RIGHT = -->\nSTOP = down arrow\nDASH = double tap key\nULT = space bar";
  
  restart.x = 500;  //restart messege
  restart.y = 480;
  restart.brush = color(255);
  restart.text = "Press 'R' to Restart or 'M' to exit to Menu";
  restart.textSize = 28;
  restart.font = "Tahoma";
  
  Menutxt.x = 430; //exit to menu messege
  Menutxt.y = 485;
  Menutxt.brush = color(0);
  Menutxt.text = "      Press ENTER to Start DEFENDING";
  Menutxt.textSize = 28;
  Menutxt.font = "Tahoma";

}
// main loop function: draw()  - draws at 60fps.
// any action must be presented here to update values or call to a function 

void draw() {
    if (!GameOn) { // game off - start screen
      startGame.draw();
      Menutxt.draw();

    } 
    else {             // game on:
      switch (level%3) { // BG drawing
        case 1: background1.draw(); break;
        case 2: background2.draw(); break;
        case 0: background3.draw(); break;
      }

      if (slashtimer > 0) {
        slash.x = ninja.x;
        slash.y = ninja.y; 
        slash.draw(); 
        slashtimer--;        
    }
      if (ExplosionTimer > 0) {
        Explosion.draw(); 
        Lightning.draw();
        ExplosionTimer--;        
    }    
    
      scoretxt.text = "score: " + score; //computing the score      
      scoretxt.draw();
      highScoretxt.draw();
      leveltxt.text = "Level " + level;
      leveltxt.draw();
      controltxt.draw();
      ninja.draw();
      
      int j = UltTimer;
      if (j < 6) {
      image(Mana[j], 490, 60, 80, 30); // name, x, y, W, H
      } else {
        ManaFull.draw();
      }
      
      if (GameOn) {
        shuriken.speed = 5 + (level/2);}      
      switch (shuriken.x%2) { // drawing shurikens
        case 0: shuriken.imageBaseName = "shurikenA_"; shuriken.draw(); break;
        case 1: shuriken.imageBaseName = "shurikenB_"; shuriken.draw(); break;
      }  

      displayLives();
    }

    if ( ninja.x < 0 || ninja.x > 924) { // keeping ninja inside canvas
      ninja.speed = 0;
    }

    if (shuriken.y > 512) {    //shuriken hits
      shuriken.x = (int)random(974);
      shuriken.y = 1;
      failed.play();
      lives--;
      createLivesArray();
    }

    if (ninja.pointInShape(shuriken.x, shuriken.y)) {  //shuriken intercepted
      shuriken.x = (int)random(974);
      shuriken.y = 1;
      success.play();
      slashtimer = 10;
      UltTimer++;
      score ++;
      scoretxt.draw();
      switch (score%6) { // levelup
        case 0: level++; lives++; break;
      }  
    }
    if ((score < highScore) && (lives <= 0)) {       // failure :
      if (!EndMessagePlayed) {
      failed.stop();
      youlose.play();
      EndMessagePlayed = true;
        }
      gameOverScreen.draw(); //<>//
      shuriken.speed = 0;
      GameOn = false;
      restart.brush = color(0);
      restart.draw();
      currentScoretxt.text = "your score: " + str(score);
      currentScoretxt.draw();


        }
    else if ((score >= highScore) && (lives <= 0)) {  // success:
      if (!EndMessagePlayed) {
      success.stop();
      victory.play(); 
      EndMessagePlayed = true;
      }
      shuriken.speed = 0; //<>//
      GameOn = false;
      highScore = score;
      highScoreScreen.draw();
      restart.brush = color(255,0,0);
      restart.draw();
      highScoretxt.draw();
      
      if (!nameEntered){
      showNameInputScreen();
      }
      highScoretxt.text = "Player: "  + playerName + " | Score: " + str(highScore);     
     
      String[] data = {playerName + "," + str(score)}; // Convert variable to a string array //<>//
      if ((!highScoreSaved) && (nameEntered)) {
        saveStrings(dataPath("highScore.txt"), data); //<>//
        highScoreSaved = true;      
      println("Saving to: " + dataPath("highScore.txt") + data[0]);
          }
        }
      }

  void createLivesArray() {
    livesImages = new PImage[10]; // Allow for up to 10 lives
    livesX = new float[10];
    livesY = new float[10];
  
  for (int i = 0; i < 10; i++) { 
          if (i <= lives) {
              livesImages[i] = loadImage("heart.png");
              livesX[i] = 950 - (i * 50);  
              livesY[i] = 1;
          } else {
              livesImages[i] = null; // Set remaining elements to null
      } } }
    
  void displayLives() {
      for (int i = 0; i < min(lives, 10); i++) {
          if(livesImages[i]!=null){
          image(livesImages[i], livesX[i], livesY[i], livesWidth, livesHeight);
       }  }  }
 
  void createBarArray() {
    Mana = new PImage[7]; 
    for (int i = 0; i < Mana.length; i++) { 
      String filename = "Ult" + i + ".png";
      Mana[i] = loadImage(filename); 
      }
    }

void showNameInputScreen() {
  enteringName = true;
  background(30);
  textSize(32);
  fill(255);
  text("Enter Your Name:", width / 2, height / 2 - 40);
  text(playerName + "_", width / 2, height / 2); // Show input with cursor
  text("Press ENTER to Confirm", width / 2, height / 2 + 40);
}

void resetGame() {
  score = 0;
  lives = 5;
  createLivesArray();
  level = 1;
  EndMessagePlayed = false;
  GameOn = true;
  UltTimer = 0;
  godmode = false; 
  // Reset shuriken 
  shuriken.x = (int)random(974);
  shuriken.y = 1;
  shuriken.speed = 5;
  // Reset ninja 
  ninja.x = 512;
  ninja.y = 412;
  ninja.speed = 0;
  nameEntered = false;
  }
  
void keyPressed() {
  if (!enteringName) { // toggle music on/off
        if (key == 's' || key == 'S' || key == 'ד') { // 3rd key is DALED
        musicOn++;          
        switch (musicOn%2) {
          case 0: GameRun.play();break;
          case 1: GameRun.stop(); break;
            }
          }
        }
  if (GameOn){
    if (keyCode == RIGHT) {
      ninja.direction = Direction.RIGHT;
      ninja.imageBaseName = "ninja_right";  // ninja object
  
      ninja.speed = 6;
      int currentTime = millis();  //double tap logic
      if (currentTime - lastPressTime < doubleTapThreshold) {
            ninja.speed = 12;
          }
      lastPressTime = currentTime;    
    } 
    else if (keyCode == LEFT) {    //double tap logic
      ninja.direction = Direction.LEFT;
      ninja.imageBaseName = "ninja_left";  // ninja object
      ninja.speed = 6;
      int currentTime = millis();  
      if (currentTime - lastPressTime < doubleTapThreshold) {
            ninja.speed = 12;
          }
      lastPressTime = currentTime;    
    } 
    else if (keyCode == DOWN) {
      ninja.speed = 0;
    } 
    else if ((keyCode == ' ' && UltTimer >= 6) || (godmode)) {
      Explosion.x = shuriken.x;
      Explosion.y = shuriken.y;    
      Lightning.x = shuriken.x - 50;
      //lightning_origin = shuriken.y;
      ExplosionTimer = 10;
      shuriken.x = (int)random(974);
      shuriken.y = 1;
      ExplosionFX.play();
      UltTimer = 0;
    }
    // god mode logic  
    lastKeys[0] = lastKeys[1];
    lastKeys[1] = lastKeys[2];
    lastKeys[2] = key;
    if ((new String(lastKeys)).equals("GOD") || (new String(lastKeys)).equals("god") || (new String(lastKeys)).equals("עםג")) {
      godmode = true; 
    }
    // controls for menu and screens
    } else if ((!enteringName) && (!GameOn)){ 
      if (keyCode == ENTER) {
        GameOn = true;
      } else if (key == 'm' || key == 'M' || key == 'צ') { // 3rd key is TZADIK 
        resetGame();
        GameOn = false;
      } else if (key == 'r' || key == 'R' || key == 'ר') { // 3rd key is REISH
        resetGame();
        }
      } 
      // high score name entering logic: //<>// //<>//
      else if (enteringName) { 
        if (key == ENTER) {
          nameEntered = true;
          enteringName = false;
          GameOn = false;
      } else if (key == BACKSPACE && playerName.length() > 0) {
        playerName = playerName.substring(0, playerName.length() - 1);
      } else if (key >= 32 && key <= 126) { // Printable characters only
        playerName += key;
      }
      }
    }
