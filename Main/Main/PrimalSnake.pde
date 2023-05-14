class PrimalSnake {
  /***************************************
   *Public Variables
   ***************************************/
  float Angle = PI/2; //Angle of moving
  float oldAngle = 0;  //Angle from one iteration before
  byte size = 10;  //startsize of the Snake
  float FieldSize = 6;            //Startsize of each Snakesegment
  int MaxLength = 1000;          //maximum length of snake
  color colour = #00FFFF;  //Colour of the Snake
  int newpos[] = new int[2];
  int startLength = 20;
  int SLength = startLength;
  boolean dead = false;
  boolean NPC = false;
  int portaltime = 0;
  int wallteletime = 0;
  int lastBody = SLength;
  int id;
  int targetFood = -1;

  ArrayList <SnakeBody> body = new ArrayList <SnakeBody>();
  float speedSnake = 1;
  boolean speedUsed = false;
  /*****************************************
   *Returns colour of Snakebody on given pos
   *****************************************/
  color BodyColour(int bodypart) {
    return color(bodypart*red(SnakeColor[SnakeColorSelected])/SLength, bodypart*green(SnakeColor[SnakeColorSelected])/SLength, bodypart*blue(SnakeColor[SnakeColorSelected])/SLength);
  }

  /***************************************
   *Moves the Snake
   ***************************************/
  void move() {    //moves snake one step in direction of angle
    nextTile();    //Moves onto next tile
    testPath();    //Tests if food, enemy, boarder, oder lvl up is on the way
    updateSnake();  //Updates snake body
  }

  void testPath() {
    testFood();
    testBlocks();
    testWalls();
  }
  void testBlocks() {
  }

  void testWalls() {
    //testWalls
    if (wallteletime > 2) {
      if (body.get(0).pos.x <= 0 || body.get(0).pos.y <= 0 || body.get(0).pos.x >= worldSize.x || body.get(0).pos.y >= worldSize.y) {
        if (body.get(0).pos.x <=0) {
          teleport(worldSize.x, body.get(0).pos.y);
          wallteletime=0;
        }
        if (body.get(0).pos.y <=0) {
          teleport(body.get(0).pos.x, worldSize.y);
          wallteletime=0;
        }
        if (body.get(0).pos.x >=worldSize.x) {
          teleport(0, body.get(0).pos.y);
          wallteletime=0;
        }
        if (body.get(0).pos.y >= worldSize.y) {
          teleport(body.get(0).pos.x, 0);
          wallteletime=0;
        }
      }
    }
    if (wallteletime <=2)
      wallteletime ++;
  }

  void testFood() {
    //TestFood
    for (int i=0; i<food.size(); i++) {
      float distance = 999;
      distance = sqrt((food.get(i).pos.x-newpos[0])*(food.get(i).pos.x-newpos[0])+(food.get(i).pos.y-newpos[1])*(food.get(i).pos.y-newpos[1]));
      if (distance >= (food.get(i).size+size)/2)
        continue;
      for (int k=0; k<food.get(i).value; k++)
        body.add(new SnakeBody(body.get(body.size()-3).pos));
      if (food.get(i).value == 0)
        continue;
      SLength+=food.get(i).value;
      maxFood+=food.get(i).value;
      food.get(i).reset();
      fillGridsFood();
    }
  }

  /***************************************
   *Finds out the next tile for the Head
   ***************************************/
  void nextTile() {
    //oldAngle = Anglecalc(body.get(1).pos[0],body.get(1).pos[1],body.get(0).pos[0],body.get(0).pos[1]);
    moveNPC();
    moveHumanPlayer();

    newpos[0] = round(body.get(0).pos.x-FieldSize*speedSnake*math.cosAlike(Angle));
    newpos[1] = round(body.get(0).pos.y-FieldSize*speedSnake*math.sinAlike(Angle));

    oldAngle = Angle;
  }


  /***************************************
   *Updates the Snake Body and Head
   ***************************************/
  void updateSnake() {
    for (int i=SLength; i>0; i--) {
      body.get(i).pos.x = body.get(i-1).pos.x;
      body.get(i).pos.y = body.get(i-1).pos.y;
    }
    
    body.get(0).pos.x = newpos[0];
    body.get(0).pos.y = newpos[1];

    Calcsize();
    FieldSize = size*0.7;
  }

  void teleport(float x, float y) {
    newpos[0] = round(x);
    newpos[1] = round(y);
  }

  void Calcsize() {
    size=byte(9.6+round((0.15)*sqrt(SLength)));
  }

  void moveNPC() {
    if (NPC == false)
      return;
    //Angle = 2*PI*noise(0.001*millis());
    if (targetFood == -1)
      targetFood = round(random(food.size()));
    if (dist(body.get(0).pos.x, food.get(targetFood).pos.x, body.get(0).pos.y, food.get(targetFood).pos.y) <= size)
      targetFood = round(random(food.size()));
    float AngleFood = math.Anglecalc(body.get(0).pos.x, body.get(0).pos.y, food.get(targetFood).pos.x, food.get(targetFood).pos.y);
    Angle = AngleFood;
  }

  void moveHumanPlayer() {
    if (NPC != false)
      return;
    if (isAndroid == true)
      moveOnAndroid();
    if (isAndroid == false)
      moveOnPC();

    Angle = math.AngleResize(Angle, oldAngle);
  }

  void moveOnAndroid() {
    Angle = AndroidAngle;
  }

  void moveOnPC() {
    // if(mouseX-pmouseX!=0 && mouseY-pmouseY!=0)  //snake moves always in the same direction
    if (id == 0) {
      int NewDirectionX = round(mouseX/ScaleScreenX+body.get(0).pos.x-dWidth/2);
      int NewDirectionY = round(mouseY/ScaleScreenY+body.get(0).pos.y-dHeight/2);
      Angle = math.Anglecalc(body.get(0).pos.x, body.get(0).pos.y, NewDirectionX, NewDirectionY);
    } else if (id == 1) {
      Angle = oldAngle + PI/15 * directionKey;
      if (Angle > 2*PI)
        Angle = Angle - 2*PI;
      else if (Angle<0)
        Angle = Angle + 2*PI;
    }
  }
}

class SnakeBody{
  PVector pos;
  int size = 10;
  color colour = #00FFFF;
  
  SnakeBody(){
    pos = new PVector(0,0);
  }
  SnakeBody(PVector p){
    pos = new PVector(p.x,p.y);
  }
}
