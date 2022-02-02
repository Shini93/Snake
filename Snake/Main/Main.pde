/********************************* //<>//
 *Global variables
 *ToDO: Add special after x runs through portal
 *********************************/
byte GameSpeed = 20;            //sets fps
byte BlockSize = 30;            //Size of all blocks
byte MaxPortals = 3;            //Maximum Portals in the game
byte maxSnakes = 1;             //not implemented yet
boolean missilealive = false;   //No Kaboom anymore
int maxRays = 720;              //Maximum number of Rays for the Raycasting

ArrayList<Food> food = new ArrayList <Food>();  //Spawns Food
ArrayList <Blocks> blocks = new ArrayList <Blocks>();

Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
MissilePath [] path = new MissilePath [100];  //creates missilepath
Ray[] ray = new Ray[maxRays];

Snake snake = new Snake();      //Snek
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();  //Chanes levels as needed

Missiles missile;               //Kaboom!


/*************************************
 *Initialises program
 *************************************/
void setup() {
  size(800, 800);                          //starting size of the game
  snake = new Snake();
  path[0] = new MissilePath();
  missile = new Missiles();
  lvls.start();                            //starts the first level
  missilealive = false;                    //No Kaboom anymore
  frameRate(GameSpeed);                    //sets the gamespeed to a 20 fps

  /*initialises the Raycasting*/
  for (int i=0; i<maxRays; i++) {
    ray[i] = new Ray(snake.pos[0][0], snake.pos[0][1], i*PI/360);
  }
}

/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/
void draw() {
  
  lvls.victory();        //Checks if the level is finished
  background(0);         //draws BG black
  DrawFood();
  DrawSnake();
  DrawMissile();
  DrawPath();
  DrawBlocks();
  DrawPortal();
  DrawText();
  /*Draws all Rays*/
  for (int i=0; i<maxRays; i++) {
    ray[i].update();
  }
}

/********************
 *handles Mouseevents
 *Starts Missles
 ********************/
void mousePressed() {
  missilealive = true;
  float dAngle;      //Angle difference between the snake head and the block with the nearest Angle
  float Angle;
  float min=2*PI;    //minumum Angle between Snake and block
  int id=0;
  for (int i=0; i<blocks.size()-1; i++) {
    Angle = Anglecalc(snake.pos[0][0], snake.pos[0][1], blocks.get(i).pos[0]+blocks.get(i).size/2, blocks.get(i).pos[1]+blocks.get(i).size/2);
    dAngle = abs(Angle - snake.Angle);
    if (dAngle<min) {
      min = dAngle;
      id = blocks.get(i).id;
    }
  }
  missile = new Missiles(id, snake.pos[0][0], snake.pos[0][1]);    //adds missile starting from the snake
}

/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  if (snake.dead==true)
    lvls.reset();
  snake.move();
  for (int i=0; i<snake.SLength; i++) {
    fill(snake.BodyColour(i));
    stroke(#000000);
    circle(snake.pos[i][0], snake.pos[i][1], snake.size);
  }
}

/**********************************
 *Draws the Portal(s)
 **********************************/
void DrawPortal() {
  if (lvl.setPortal) {
    for (byte i=0; i<MaxPortals; i++) {      //repeat for every portal in existance
      strokeWeight(3);
      stroke(portal[i].colour1);
      fill(#D8FFF8);
      ellipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size*0.5, portal[i].size);
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
  for (int i=0; i<lvl.maxFood; i++) {
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
  if (missilealive == true) {
    missile.move();
    fill(#FF0000);
    circle(missile.pos[0], missile.pos[1], 3);
  }
}

/**************************************
 *Draws the Path of the Missile
 **************************************/
void DrawPath() {
  if (missile.alive!=0) {
    path[missile.alive-1] = new MissilePath(missile.pos[0], missile.pos[1]);
    for (int i=0; i<missile.alive-1; i++) {
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
    fill(blocks.get(i).colour);
    rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
    blocks.get(i).colour = 0;
  }
}

/**************************
*Draws all Text on screen
**************************/
void DrawText() {
  textSize(30);
  fill(255);
  text("Snake Size: "+snake.SLength + "\nposx" +snake.pos[0][0] +"\nposy"+snake.pos[0][1] +"\nAngle "+snake.Angle*180/PI + "\nDead: "+lvls.Killcount, 0, 30);
}
/***************************************
 *Calculates between mouse and Snakehead
 ***************************************/
float Anglecalc(float x, float y, float x2, float y2) {    //Angle between mouse and Snake
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
