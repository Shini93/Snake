/*************************************
 *Initialises program
 *************************************/
void setup() {
  size(800, 800);
  int k=0;
  snake = new Snake();
  path[0] = new MissilePath();
  missile = new Missiles();
  for (int i=0; i<maxFood; i++) {
    food[i] = new Food(i, k);
    k=0;
    if (i==3 || i==6)
      k=1;
  }
  for (int i=0; i<10;i++)
    blocks[i] = new Blocks(i);
  frameRate(GameSpeed);
}

/*********************************
 *Global variables
 *********************************/
byte maxFood = 100;
byte GameSpeed = 20;
Food[] food = new Food[maxFood];
Snake snake = new Snake();
Missiles missile;
boolean missilealive = false;
MissilePath [] path = new MissilePath [100];
Blocks[] blocks = new Blocks[10];
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
    stroke(#000000);
    line(snake.pos[0][0],snake.pos[0][1],snake.pos[0][0]+1000*sin(Angle),snake.pos[0][1]-1000*cos(Angle));
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
    path[missile.alive-1] = new MissilePath(missile.pos[0], missile.pos[1], byte(0));
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
  float dx = -x+x2;
  float dy = y-y2;
  float Angle;
  float d=sqrt(dx*dx+dy*dy);
  Angle = acos(dy/d);
  if(dx < 0)
    Angle = 2*PI-Angle;
  //print(Angle+ "    "+snake.pos[0][0]+  "      "+ mouseX+"\n");
  
/*  float Angle = 2*atan(dy/sqrt(dx*dx+dy*dy));
  if (dx<0 && dy<0)    //2. quadrant
    Angle = 2*PI+Angle;
  if (dx<0 && dy>=0)    //1. quadrant
  {
  }
  if (dx>=0 && dy<0)    //3. quadrant
    Angle = PI-Angle;
  if (dx>=0 && dy>=0)    //4. quadrant
    Angle = PI-Angle;
    */
  return Angle;
}
