/********************************* //<>//
 *Global variables
 *ToDO: Add special after x runs through portal
 *********************************/
byte GameSpeed = 20;            //sets fps
byte BlockSize = 30;            //Size of all blocks
byte MaxPortals = 3;            //Maximum Portals in the game
byte maxSnakes = 1;             //not implemented yet

int maxRays = 720;              //Maximum number of Rays for the Raycasting
int marginX = 200;
int marginY = 100;
int fadeBlocks = 20;
int maxFood = 0;
int maxLevel = 1;
ArrayList<Food> food = new ArrayList <Food>();  //Spawns Food
ArrayList <Blocks> blocks = new ArrayList <Blocks>();
color[] SnakeColor = {#AAFFFF , #FF7E80, #FF7EF0, #917EFF, #7EC0FF, #7EFFB9, #A4FF7E, #FFFB7E, #FFB27E, #FFFFFF};
int SnakeColorSelected = 0;

Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
MissilePath [] path = new MissilePath [100];  //creates missilepath

Snake[] snake = new Snake[3];      //Snek
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();  //Chanes levels as needed



/*************************************
 *Initialises program
 *************************************/
void SetupSnake(){
  snake[0] = new Snake(false,int(random(800)),int(random(800)));
  snake[0].initRays();
  snake[0].missile = new Missiles();
  for(int i=1;i<snake.length;i++){
    snake[i] = new Snake(true,int(random(800)),int(random(800))); //<>//
    snake[i].initRays();
    snake[i].missile = new Missiles();
  }
  path[0] = new MissilePath(); //<>//
  
  
  snake[0].missilealive = false;                    //No Kaboom anymore
  lvls.start();                            //starts the first level
  frameRate(GameSpeed);                    //sets the gamespeed to a 20 fps

  /*initialises the Raycasting*/
  
}

/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/
void draw() {
  if(shopmenu == true)
    showSnake();
  if(GameStart == false)
    return;
  background(0);
  lvls.victory();        //Checks if the level is finished
  
  fill(0);
  stroke(255);
  rect(200,100,800,800);
  
  push();
  translate(200,100);
  for(int k=0;k<snake.length;k++){
    for (int i=0; i<maxRays; i++) {
      snake[k].ray[i].update(snake[k].body.get(0).pos[0],snake[k].body.get(0).pos[1],snake[k].Angle);
    }
  }
  DrawFood();
  DrawSnake();
  DrawMissile();
  DrawPath();
  DrawBlocks();
  DrawPortal();
  DrawText();
  pop();

}

/********************
 *handles Mouseevents
 *Starts Missles
 ********************/
void mousePressed() {
  if(GameStart== false)
    return;
  snake[0].missilealive = true;
  float dAngle;      //Angle difference between the snake head and the block with the nearest Angle
  float Angle;
  float min=2*PI;    //minumum Angle between Snake and block
  int id=0;
  for (int i=0; i<blocks.size()-1; i++) {
    Angle = Anglecalc(snake[0].body.get(0).pos[0], snake[0].body.get(0).pos[1], blocks.get(i).pos[0]+blocks.get(i).size/2, blocks.get(i).pos[1]+blocks.get(i).size/2);
    dAngle = abs(Angle - snake[0].Angle);
    if (dAngle<min) {
      min = dAngle;
      id = blocks.get(i).id;
    }
  }
  snake[0].missile = new Missiles(id, snake[0].body.get(0).pos[0], snake[0].body.get(0).pos[1]);    //adds missile starting from the snake
}

/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  if (snake[0].dead==true)
    lvls.reset();
  for(int k=0;k<snake.length;k++){
    snake[k].move();
    for (int i=0; i<snake[k].SLength; i++) {
      fill(snake[k].BodyColour(i),255);
      stroke(#000000);
      circle(snake[k].body.get(i).pos[0], snake[k].body.get(i).pos[1], snake[k].size);
      fill(snake[k].BodyColour(i),40);
      noStroke();
      circle(snake[k].body.get(i).pos[0], snake[k].body.get(i).pos[1], snake[k].size+10);
      stroke(1);
    }
  }
}

/**********************************
 *Draws the Portal(s)
 **********************************/
void DrawPortal() {
  if (lvl.setPortal) {
    for (byte i=0; i<MaxPortals; i++) {      //repeat for every portal in existance
      strokeWeight(3);
      stroke(portal[i].colour1,30);
      ellipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size*0.5+2, portal[i].size+4);
      stroke(portal[i].colour1);
      fill(#D8FFF8);
      ellipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size*0.5, portal[i].size);
      
      stroke(portal[i].colour2,30);
      ellipse(portal[i].pos[1][0], portal[i].pos[1][1], portal[i].size*0.5+2, portal[i].size+4);
      stroke(portal[i].colour2);
      fill(#FFE815);
      ellipse(portal[i].pos[1][0], portal[i].pos[1][1], portal[i].size*0.5, portal[i].size);
      
    }
    strokeWeight(1);
  }
}

/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {
  for (int i=0; i<food.size(); i++) {
    if (food.get(i).size == 30) {                //if food has no rays on it
      drawGradient(food.get(i).posx, food.get(i).posy, food.get(i).size);    //draw a circle with blurry circumfence
    } else {                                     //food is seen by the rays
      fill(food.get(i).BGcolour);
      stroke(food.get(i).colour);
      ellipse(food.get(i).posx, food.get(i).posy, food.get(i).size, food.get(i).size);
      food.get(i).colour = 0;                    //resets food to not seen every time
      food.get(i).BGcolour = #00160D;
      food.get(i).size = 30;
    }
  }
}

/**********************************
*Draws the gradient of food
***********************************/
void drawGradient(float x, float y, int size) {
  int radius = size;
  float h = 255;                    //fades the circle out
  for (int r = radius; r > 0; --r) {
    noStroke();  
    fill(max(50-h, 0), max(50-h, 9), max(255-h, 0), 5);
    circle(x, y, r);
    h-=10;
  }
}

/**************************************
 *Draws the Missile
 **************************************/
void DrawMissile() {
  for(Snake s : snake){
    if (s.missilealive == true) {
      s.missile.move();
      fill(#FF0000);
      circle(s.missile.pos[0], s.missile.pos[1], 3);
      fill(#FFAAAA,50);
      circle(s.missile.pos[0], s.missile.pos[1], 9);
    }
  }
}

/**************************************
 *Draws the Path of the Missile
 **************************************/
void DrawPath() {
  for(Snake s: snake ){
    if(s == null || s.missile.alive ==0)
      return;
    path[s.missile.alive-1] = new MissilePath(s.missile.pos[0], s.missile.pos[1]);
    for (int i=0; i<s.missile.alive-1; i++) {
      if (path[i].alive >= 0) {
        fill(#FFFFFF, path[i].fade);
        circle(path[i].pos[0], path[i].pos[1], path[i].size);
        path[i].update();
      }
    }
  }
}

/**************************
*Draws all blocks on screen
**************************/
void DrawBlocks() {
  for (int i=0; i<lvl.blocksize/2-1; i++) {
    if(blocks.get(i).RayCast == true){
      noStroke();
      fill(blocks.get(i).colour,50);
      rect(blocks.get(i).pos[0]-3, blocks.get(i).pos[1]-3, blocks.get(i).size+6, blocks.get(i).size+6);
    
      stroke(1);
      fill(blocks.get(i).colour);
      rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
      blocks.get(i).RayCast = false;
    }
    fill(blocks.get(i).colour,blocks.get(i).fade);
    stroke(1);
    rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
    blocks.get(i).fade= max(blocks.get(i).fade-10,0);
  }
}

/**************************
*Draws all Text on screen
**************************/
void DrawText() {
  textSize(30);
  fill(255);
  String text = "FoodCount: "+ maxFood+
   "\nSnake Size: "+snake[0].SLength+
   "\nposx" +snake[0].body.get(0).pos[0]+
   "\nposy"+snake[0].body.get(0).pos[1]+
   "\nAngle "+snake[0].Angle*180/PI+
   "\nDead: "+lvls.Killcount;
  text(text, 0, 30);
}

/***************************************
 *Calculates between mouse and Snakehead
 ***************************************/
float Anglecalc(int x, int y, int x2, int y2) {    //Angle between mouse and Snake
  float dx = x2-x;
  float dy = y-y2;
  float Angle;
  float d=sqrt(dx*dx+dy*dy);
  Angle = acos(dy/d);
  if (dx < 0)
    Angle = 2*PI-Angle;
  return Angle;
}

/**************************
*Calculates the distance
**************************/
float distance (int x1, int y1, int x2, int y2) {
  int dx = x1-x2;
  int dy = y1-y2;
  return sqrt(dx*dx+dy*dy);
}
