/*********************************
*Global variables
*ToDO: Add special after x runs through portal
*********************************/
byte GameSpeed = 20;            //sets fps
byte BlockSize = 30;            //Size of all blocks
//int maxBlocks = 1000;
byte MaxPortals = 3;            //Maximum Portals in the game
byte maxSnakes = 1;
boolean missilealive = false;   //No Kaboom anymore
ArrayList<Food> food = new ArrayList <Food>();  //Spawns Food
Snake snake = new Snake();      //Snek
Missiles missile;               //Kaboom!
MissilePath [] path = new MissilePath [100];  //creates missilepath
ArrayList <Blocks> blocks = new ArrayList <Blocks>();
//Blocks[] blocks = new Blocks[1000];  //creates Blocks  //TODO: cannot load more blocks fir diff. lvls, eiter use max. block count here, or use arraylist
Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();
/*************************************
 *Initialises program
 *************************************/

void setup() {
  size(800, 800);                          //starting size of the game
  path[0] = new MissilePath();             
  missile = new Missiles();
  lvls.start();
  missilealive = false;   //No Kaboom anymore
  snake = new Snake();
  frameRate(GameSpeed);
}

/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/
void draw() {
  lvls.victory();
  background(125);
  DrawFood();
  DrawSnake();
  DrawMissile();
  DrawPath();
  DrawBlocks();
  DrawPortal();
  DrawText();
}

/********************
 *handles Mouseevents
 *Starts Missles
 ********************/
void mousePressed() {
  missilealive = true;
  float dAngle;
  float Angle;
  float min=2*PI;
  int id=0;
  for(int i=0;i<blocks.size()-1;i++){
    Angle = Anglecalc(snake.pos[0][0],snake.pos[0][1],blocks.get(i).pos[0]+blocks.get(i).size/2,blocks.get(i).pos[1]+blocks.get(i).size/2);
    dAngle = abs(Angle - snake.Angle);
    if(dAngle<min){
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
  if(snake.dead==true)
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
void DrawPortal(){
  if(lvl.setPortal){
    for(byte i=0;i<MaxPortals;i++){
        strokeWeight(3);
        stroke(portal[i].colour1);
        fill(#D8FFF8);
        ellipse(portal[i].pos[0][0],portal[i].pos[0][1],portal[i].size*0.5,portal[i].size);
        stroke(portal[i].colour2);
        fill(#FFE815);
        ellipse(portal[i].pos[1][0],portal[i].pos[1][1],portal[i].size*0.5,portal[i].size);
    }
    strokeWeight(1);
  }
}

/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {
  for (int i=0; i<lvl.maxFood; i++) {
    fill(food.get(i).BGcolour);
    stroke(food.get(i).colour);
    ellipse(food.get(i).posx, food.get(i).posy, food.get(i).size, food.get(i).size);
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
      if(path[i].alive >= 0){
        fill(#FFFFFF, path[i].fade);
        circle(path[i].pos[0], path[i].pos[1], path[i].size);
        path[i].update();
      }
    }
  }
}

void DrawBlocks(){
 for(int i=0;i<lvl.blocksize/2;i++){
   fill(blocks.get(i).colour);
   rect(blocks.get(i).pos[0],blocks.get(i).pos[1],blocks.get(i).size,blocks.get(i).size);
 } 
}

void DrawText(){
 textSize(30);
 fill(0);
 text("Snake Size: "+snake.SLength + "\nposx" +snake.pos[0][0] +"\nposy"+snake.pos[0][1] +"\nAngle "+snake.Angle*180/PI + "\nDead: "+lvls.Killcount,0,30);
 
  
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
  if(dx < 0)
    Angle = 2*PI-Angle;
  return Angle;
}

float distance (int x1, int y1,int x2,int y2){
  int dx = x1-x2;
  int dy = y1-y2;
  //return sqrt((x1+y1)*(x1+y1)+(x2+y2)*(x2+y2));
  return sqrt(dx*dx+dy*dy);
}
