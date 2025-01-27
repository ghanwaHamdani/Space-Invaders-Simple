/*
Ghanwa Hamdni
ICS3U1
Space Invaders Assignment - Unit 3
May 1, 2023
*/

//VARIABLE START
int gameState = 0; //0 = menu, 1 = instructions, 2 = easy setting, 3 = lose game, 4 = hard setting, 5 = win game, 6 = transition

//for images
PFont font;
PImage enterKey;
PImage shiftKey;
PImage spaceBar;
PImage alienA;
PImage alienB;

PImage tank;
PImage bullet;
PImage gameOver;
int xSpeed = 2;

//for array
int numRows = 5;
int numCols = 11;
int numberOfAliens = 11;

//array
int[] bullets = new int[1];
int[] blueAliensY = new int[numberOfAliens];
int[] blueAliensX = new int[numberOfAliens];
int[] purpleAliensX = new int[numberOfAliens];
int[] purpleAliensY = new int[numberOfAliens];

//booleans
boolean tankRight;
boolean tankLeft;
boolean bulletRight;
boolean bulletLeft;
boolean bulletShoot;
boolean moveAlienY;
boolean winGame;
boolean hitAlien;

//tank
int tankX = 0;
int tankY = 700;
int tankSpeed = 5;

//bullet
int bulletXSpeed = 5;
int bulletYSpeed = 5;
int bulletX = 30;
int bulletY = 730;

//for collision
int alienWidth = 50;
int range = 5;
int alienDead = 10;
int score = 0;

//VARIABLE END
void setup(){
  //sets format 
  size(800,800);
  textAlign(CENTER,CENTER);
  //loads/creates the font
  font = createFont("font.ttf",128);
  //loads the images of all elements needed in the game
  enterKey = loadImage("enter.png");
  shiftKey = loadImage("shiftKey.png");
  spaceBar = loadImage("space.png");
  tank = loadImage("tank.png");
  alienA = loadImage("alienA.png");
  alienB = loadImage("alienB.png");
  bullet = loadImage("bullet.png");
  gameOver = loadImage("gameOver.jpeg");
  //starting position
  setSpriteInitialPosition();
  alienDead = 0;
}

void draw(){
  background(#000000);
  textFont(font);
  extras();
  tankCollision();
  alienCollision();
  moveBullet();
  shootBullet();
  checkIfBulletHitsAlien();
  
  //game state conditionals
  if(gameState == 0){
    drawMenu();
  }
  if(gameState == 1){
    instructions();
  }
  if(gameState == 2){    
    levelEasy(); 
  }
  if(gameState == 3){
    loseGame();
  }
  if(gameState == 4){
    levelHard();
  }
  if(gameState == 5){
    winGame();
  }
  
}

//START GAME STATES
void drawMenu(){
  textSize(70);
  text("SPACE INVADERS", 400,300);
  textSize(20);
  text("easy",370,370);
  image(enterKey,420,362);
  enterKey.resize(70,22);
  text("hard",370,400);
  image(spaceBar,420,389);
  spaceBar.resize(75,30);
  text("instructions",370,430);
  image(shiftKey,420,420);
  shiftKey.resize(70,22);
}

void instructions(){
  textSize(50);
  text("HOW TO PLAY",400,250);
  textSize(20);
  text("use the right and left arrow keys to move the tank",400,300);
  text("use the up arrow key to shoot the aliens",400,330);
  text("goal: protect the earth by killing the aliens",400,360);
  text("press enter key for easy or space bar for hard",400,450);
}

void levelEasy(){
  drawBullet(bulletX, bulletY);
  moveAliens();
  drawBlueAliens();
  drawTank();
  drawScore();
}

void levelHard(){
  moveAliens();
  drawBullet(bulletX, bulletY);
  drawBlueAliens();
  drawPurpleAliens();
  drawTank();
  drawScore();
}

void loseGame(){
  image(gameOver,130,200);
  
}

void winGame(){
  textSize(80);
  fill(#FDDA0D);
  text("C O N G R A T U L A T I O N S",400,300);
  textSize(50);
  fill(#008000);
  text("Y O U  H A V E  S A V E D  E A R T H",400,370);
  
  
}
//END GAME STATES


//START ALIENS
void setSpriteInitialPosition(){
  //determines the satrting position for the array of aliens
  for(int i = 0; i < blueAliensX.length; i++){
    blueAliensX[i] = 110 + 50*(i%numCols);
    blueAliensY[i] = 150 + 50*(i/numCols);
    purpleAliensX[i] = 110 + 50*(i%numCols);
    purpleAliensY[i] = 200 + 50*(i/numCols);
  }
}


void drawBlueAliens(){
 for(int i = 0; i < blueAliensX.length; i++){ 
    //draws the array of aliens
    image(alienA, blueAliensX[i],blueAliensY[i]);
  }
}

void drawPurpleAliens(){
  for(int i = 0; i < purpleAliensX.length; i++){
    image(alienB, purpleAliensX[i],purpleAliensY[i]);
  }
}


void moveAliens(){
  if (!moveAlienY){
    moveAliensX();
  }
  else {
    moveAliensY();
    xSpeed = -xSpeed;
    moveAliensX();
  }
}

void moveAliensX (){
  //horizontal movement..
  for (int i = 0; i < blueAliensX.length;i++){
    blueAliensX[i] = blueAliensX[i] + xSpeed;
    purpleAliensX[i] = purpleAliensX[i] + xSpeed;
  }
   
}

void moveAliensY(){
  //vertical movement...
  for(int i = 0; i < blueAliensX.length; i++){
    if(blueAliensX[i] > 0 || blueAliensX[i] < 740){
       blueAliensY[i] = blueAliensY[i] + 10;
    }
    if(purpleAliensX[i] > 0 || purpleAliensX[i] < 740){
       purpleAliensY[i] = purpleAliensY[i] + 10;
    }
  }
}


void alienCollision(){
  //if the aliens touch the horizontal boundaries they should move down...
  for(int i = 0; i < blueAliensX.length; i++){
    if(blueAliensX[i] < 500|| blueAliensX[i] > 740){
      moveAlienY = true;
    }
    
    if(purpleAliensX[i] < 500|| purpleAliensX[i] > 740){
      moveAlienY = true;
    }
    
    else {
      moveAlienY = false;
    }
    //if the aliens reach the tank --> game over (game state 3)
    if(blueAliensY[i] > 700 || purpleAliensY[i] > 700){
      gameState = 3;
    }
  }
  
}
//END ALIENS

//START TANK
void drawTank(){
  image(tank,tankX,tankY);
  
  //if the tankRight is true...
  if (tankRight){
    //the tank should move toward the right
    tankX = tankX + tankSpeed;
  }
  
  //if the tankLeft is true...
  if (tankLeft){
    //the tank should move toward the right
    tankX = tankX - tankSpeed;
  }
    
}

void tankCollision(){
  //if the tank touches the horzontal boudaries, it should move in the opposte direction
  if (tankX < 0){
    tankX = tankX + tankSpeed;
  }
  if (tankX > 740){
    tankX = tankX - tankSpeed;
  }
}

void keyPressed(){
  if (keyCode == 39){ //right arrow key
    tankRight = true;
    bulletRight = true;
  }
  if (keyCode == 37){ //left arrow key
    tankLeft = true;
    bulletLeft = true;
  }
  if(keyCode == 38){  //up arrow key
    bulletShoot = true;
  }
  if(keyCode == 16){ //shift key
    gameState = 1;
  }
  if(keyCode == 10){ //enter
    gameState = 2;
  }
  if(keyCode == 8){ //back space
    gameState = 0;
  }
  if(keyCode == 32){ //space bar
    gameState = 4;
  }
  
}

void keyReleased(){
  if (keyCode == 39|| keyCode == 37){
    tankRight = false;
    tankLeft = false;
    bulletRight = false;
    bulletLeft = false;
  }
}
//END TANK

//START BULLET
void moveBullet(){
  if(bulletRight){
    bulletX = bulletX + bulletXSpeed;
  }
  if(bulletLeft){
    bulletX = bulletX - bulletXSpeed;
  }
}

void drawBullet(int x, int y){
  stroke(#FFFFFF);
  strokeWeight(5);
  line(x,y,x,y + 10);
  
  if (bulletX < 30){
    bulletX = bulletX + tankSpeed;
  }
  if (bulletX > 770){
    bulletX = bulletX - tankSpeed;
  }
  if(bulletY < 0){
    bulletY = tankY + 30;
    bulletX = tankX + 30;
    bulletShoot = false;
  }
  
}
void shootBullet(){
  if(bulletShoot){
    bulletY = bulletY - bulletYSpeed;
    bulletRight = false;
    bulletLeft = false;
  }
}


void checkIfBulletHitsAlien(){
  //if the bullet hits one of the aliens...
  for(int i = 0; i < blueAliensX.length; i++){
    if(bulletY == blueAliensY[i] && bulletX < blueAliensX[i] + alienWidth + range && bulletX > blueAliensX[i] - range){
      //the alien should be removed from the screen
      blueAliensX[i] = -1000;
      hitAlien = true;
      
    } 
    
    if(bulletY == purpleAliensY[i] && bulletX < purpleAliensX[i] + alienWidth + range && bulletX > purpleAliensX[i] - range){
      //the alien should be removed from the screen
      purpleAliensX[i] = -1000;
      hitAlien = true;

    } 
  }
  
  if(hitAlien){
    bulletY = tankY + 30;
    bulletX = tankX + 30;
    score = score + 10;
    alienDead = alienDead + 1 ;
    hitAlien = false;
    bulletShoot = false;
  }
 
}
//END BULLET


//extra details
void drawScore(){
  textSize(30);
  text("S C O R E <",100,30);
  text(score,170,30);
  text(">",190,30);
}
void extras(){
  line(0,70,800,70);
  if(alienDead == 11){
    gameState = 4;
  }
  if(alienDead == 33){
    gameState = 6;
  }
}
