/*********************************
*Global variables
*ToDO: Add special after x runs through portal
*********************************/
byte maxFood = 100;
byte GameSpeed = 20;
byte MaxPortals = 3;
byte BlockSize = 30;
Food[] food = new Food[maxFood];
Level lvl = new Level();
Snake snake = new Snake();
Missiles missile;
boolean missilealive = false;
MissilePath [] path = new MissilePath [100];
Blocks[] blocks = new Blocks[lvl.maxBlocks];
Portal[] portal = new Portal[MaxPortals];
/*************************************
 *Initialises program
 *************************************/
 
void setup() {
  size(800, 800);
  int k=0;
  path[0] = new MissilePath();
  missile = new Missiles();

 // for (int i=0; i<lvl.maxBlocks;i++)
   // blocks[i] = new Blocks(i,2,3);
  lvl.callBlocks(byte(1));
  for(byte i=0;i<MaxPortals;i++)
    portal[i] = new Portal();
  snake = new Snake();
  frameRate(GameSpeed);
}

/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/
void draw() {
  background(125);
  DrawFood();
  DrawSnake();
  DrawMissile();
  DrawPath();
  DrawBlocks();
  DrawPortal();
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
  for(Blocks b : blocks){
    Angle = Anglecalc(snake.pos[0][0],snake.pos[0][1],b.pos[0]+b.size/2,b.pos[1]+b.size/2);
    dAngle = abs(Angle - snake.Angle);
    if(dAngle<min){
      min = dAngle;
      id = b.id; 
    }
  }
  missile = new Missiles(id, snake.pos[0][0], snake.pos[0][1]);    //adds missile starting from the snake
}

/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  if(snake.dead==true)
    snake = new Snake();
  snake.move();
  for (int i=0; i<snake.SLength; i++) {
    fill(snake.colour);
    stroke(#000000);
    circle(snake.pos[i][0], snake.pos[i][1], snake.size);
  }
}

/**********************************
 *Draws the Portal(s)
 **********************************/
void DrawPortal(){
  for(Portal p : portal){
    strokeWeight(3);
    stroke(p.colour1);
    fill(#D8FFF8);
    ellipse(p.pos[0][0],p.pos[0][1],p.size*0.5,p.size);
    stroke(p.colour2);
    fill(#FFE815);
    ellipse(p.pos[1][0],p.pos[1][1],p.size*0.5,p.size);
  }
  strokeWeight(1);
}

/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {
  for (int i=0; i<maxFood; i++) {
    fill(food[i].BGcolour);
    stroke(food[i].colour);
    ellipse(food[i].posx, food[i].posy, food[i].size, food[i].size);
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
 for(Blocks b : blocks){
   fill(b.colour);
   rect(b.pos[0],b.pos[1],b.size,b.size);
 } 
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
