/***********************************
 *Handles all about Food and upgrades
 ***********************************/
class Food {
  /*********************************
   *Public variables
   *********************************/
  int size;              //size of the food
  int normalSize = 0;    //sets the normal foodsize for animations
  int id;                //foodID
  int FoodKind;          //0 = normal; 1 = big chunk; 2 = special gold
  PVector pos;
  int BGcolour;
  int colour = color(#FFFFFF);
  int value;                     //How much a snake grows when eating it
  int countSnake;
  int fade = 0;
  boolean outofBounds = true;    //out of sight from Screen

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /********************************
   *Overloaded constructor
   ********************************/
  Food(int aid, int foodkind) {
    id = aid;
    FoodKind = foodkind;
    pos =  new PVector (int(random(worldSize.x-2*GridSize))+GridSize, int(random(worldSize.y-2*GridSize))+GridSize);
    init();
  }
  Food(int aid, int foodkind, int x, int y) {
    id = aid;
    FoodKind = foodkind;
    pos = new PVector(x, y);
    init();
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /**************************************
   *resets the Food and respawns it
   **************************************/
  void reset() {
    //log.append("food.reset");
    Boolean overlap = true;            //Must not be inside a block
    countSnake = 0;
    while (overlap) {
      overlap = false;
      pos = new PVector(int(random(worldSize.x)), int(random(worldSize.y)));
      for (int i=0; i<blocks.size()-1; i++) {
        if (pos.x>=blocks.get(i).pos.x+blocks.get(i).size)
          continue;
        if (pos.x<=blocks.get(i).pos.x)
          continue;
        if (pos.y>blocks.get(i).pos.y && pos.y<blocks.get(i).pos.y+blocks.get(i).size) {
          overlap = true;
          break;
        }
      }
    }
    float foodVal = random(1);
    if (foodVal < 0.1)
      FoodKind = 2;
    else if (foodVal < 0.3)
      FoodKind = 1;
    else
      FoodKind = 0;
    init();
    checkLanterns();
  }

  void checkLanterns(){
    if(laternen.size() <= 0)
      return;
    for(int l = 0; l < laternen.size(); l++){
      float d = dist(pos.x,pos.y,laternen.get(l).pos.x,laternen.get(l).pos.y);
      if(d > laternen.get(l).getSize())
        continue;
       fade = 255;
       countSnake = laternen.get(l).findFade(pos,laternen.get(l).getSize());
    }
      
  }

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  /**************************************
   *defines the parameters
   **************************************/
  void init () {
    //log.append("food.init");
    //   colour = color(#FFFFFF);
    if (FoodKind == 0) {    //Green
      size = 5;
      normalSize = 5;
      BGcolour = color(#00FF00);
      value = 1;
      fade = 0;
    } else if (FoodKind ==1) {
      size = 10;
      normalSize = 10;
      BGcolour = color(#0000FF);  //Blue
      value = 5;
      fade = 0;
    } else {
      size = 15;
      normalSize = 15;
      BGcolour = color(#FF0000);  //Red
      value = 0;                    //Adds Special after some time
      fade = 255;
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************
 *Block class
 *Blocks defined in lvl system
 *****************************/
class Blocks {
  // int[] pos = new int[2];    //x,y position
  PVector pos;
  color colour = 255;          //startcolor is black
  int size = 30;
  int id;
  boolean RayCast = false;
  boolean outofBounds = true;
  int fade = 0;
  int countSnake;

  Blocks(int ida, int x, int y) { //overloaded constructor
    pos = new PVector(x, y);
    id = ida;                //Block ID not implemented yet
  }

  Blocks(int ida) {            //overloaded constructor
    id = ida;
  }

  void reset() {              //has to be changed to positions on the grid.
    //log.append("blocks.reset");
    pos = new PVector(round(random(dWidth)/30)*30, round(random(dHeight)/30)*30);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class movingTiles {
  int blockID;
  int[][] Path = new int[20][2];
  int StepMovingBlock=0;
  byte rectcorner = 0;
  byte maxCorner = 0;

  movingTiles(int id, int[][] PATH ) {
    blockID = id;
    Path = PATH;
    while (PATH[maxCorner][0] > 0)
      maxCorner++;
    //maxCorner = byte(PATH.length-1);
  }
  void reset() {
    //log.append("moving blocks.reset");
    rectcorner=0;
    StepMovingBlock=0;
    int[][] dummy = new int[20][2];
    Path = dummy;
    maxCorner = 0;
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class Portal {
  int[][] pos = new int[2][2];
  color colour1 = color(random(255), random(255), random(255));
  color colour2 = colour1;
  int size = 20;
  int id;

  Portal() {
    pos[0][0] = int(random(dWidth));
    pos[0][1] = int(random(dHeight));
    pos[1][0] = int(random(dWidth));
    pos[1][1] = int(random(dHeight));
  }
  Portal(int[] posstart) {
    pos[0][0] = posstart[0];
    pos[0][1] = posstart[1];
    pos[1][0] = posstart[2];
    pos[1][1] = posstart[3];
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class Special {
  PVector pos;
  color colour = 255;          //startcolor is black
  int size = 30;
  int id;
  boolean RayCast = false;
  //TODO: Add special for overall speed, size of the minisnakes

  int fade = 0;
  int Specialvalue;          //rocketNr, speed, miniSnakes, rayDist, rayRad, radiation
  Special(int Value, int snakeID) {
    pos = new PVector(snake[snakeID].body.get(snake[snakeID].body.size()-2).pos.x,
      snake[snakeID].body.get(snake[snakeID].body.size()-2).pos.y);

    Specialvalue = Value;
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class Laterne {
  PVector pos;
  int lebensDauer = 30 * 120;  //120 seconds if all works well :p
  int id;
  float sizeToLifeRatio = 2;
  Laterne(PVector pos, int id) {
    this.pos = new PVector(pos.x, pos.y);
    this.id = id;

    findEntities( getSize());
  }

  int getSize() {
    return round(sizeToLifeRatio * lebensDauer / 30);
  }

  void findEntities(int size) {
    for (int f = 0; f < food.size(); f++) {
      int maxFade = findFade(food.get(f).pos, size);
      food.get(f).countSnake = max(food.get(f).countSnake, maxFade);
    }
    for (int b = 0; b < blocks.size(); b++) {
      int d = round(dist(blocks.get(b).pos.x, blocks.get(b).pos.y, pos.x, pos.y));
      if ( d > size)
        continue;
      int maxFade = round ( 30 / sizeToLifeRatio ) * (size - d);
      blocks.get(b).countSnake = max(blocks.get(b).countSnake, maxFade);
    }
  }

  int findFade(PVector f, int size) {
    int d = round(dist(f.x, f.y, pos.x, pos.y));
    if ( d > size)
      return 0;
    return round (30 / sizeToLifeRatio) * (size - d);
  }

  void drawOnScreen() {
    drawOnScreen(pos.x,pos.y);
    int size = getSize();
    if(pos.x + size > worldSize.x)  //links nach rechts
      drawOnScreen( pos.x - worldSize.x,pos.y);
      
    if(pos.x - size < 0)  //rechts nach links
      drawOnScreen(worldSize.x + pos.x,pos.y);
      
    if(pos.y + size > worldSize.y)  //oben
      drawOnScreen(pos.x,pos.y - worldSize.y);
    if(pos.y - size < 0)  //unten
      drawOnScreen(pos.x,worldSize.y + pos.y);
    lebensDauer--;
  }
  
  void drawOnScreen(float xOffset, float yOffset) {
    if (lebensDauer <= 70) {
      for(int i = laternen.size() - 1; i > id ; i--)
        laternen.get(i).id --;
      laternen.remove(id);
      return;
    }
    SnakeGraphic.image(lantern, xOffset - 32, yOffset- 32);

    SnakeGraphic.fill(255, 20);
    int size = 2 * round(sizeToLifeRatio * lebensDauer / 30);
    SnakeGraphic.ellipse(xOffset, yOffset , size, size);
  }
}

void lightenEntities(){
  for(Blocks b : blocks)
    b.fade = 255;
  for(Food f : food)
    f.fade = 255;  
}
