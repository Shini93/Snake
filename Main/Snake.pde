/******************************************
 *Handles all about Snakes
 ******************************************/
class Snake {
  /***************************************
   *Public Variables
   ***************************************/
  float Angle = PI/2; //Angle of moving
  float posx = width/2;
  float posy= height/2;
  byte size = 10;
  color colour = color(#00FFFF);
  float FieldSize = 7;
  int MaxLength = 1000;      //maximum length of snake
  float pos[][] = new float [MaxLength][2]; //  [Head][x,y]
  float newpos[] = new float[2];
  int startLength = 20;
  int SLength = startLength;
  boolean dead = false;
  /***************************************
   *Constructor
   ***************************************/
  Snake() {
    for (int k = 0; k<20; k++) {
      pos[0][0] = width/2+10*k;
      pos[0][1] = height/2+2*k;
    }
  }

  /***************************************
   *Moves the Snake
   ***************************************/
  void move() {    //moves snake one step in direction of angle
    nextTile();    //Moves onto next tile
    testPath();    //Tests if food, enemy, boarder, oder lvl up is on the way
    updateSnake();  //Updates snake body
  }
   

  /***************************************
   *Finds out the next tile for the Head
   ***************************************/
  void nextTile() {
    Angle = Anglecalc(pos[0][0],pos[0][1],mouseX,mouseY);
    newpos[0] = (pos[0][0]+FieldSize*cos(Angle));
    newpos[1] = (pos[0][1]-FieldSize*sin(Angle));
  }

  /***************************************
   *Tests if the Path is free
   ***************************************/
  void testPath() {
    //TestFood
    for (int i=0; i<maxFood; i++) {
      float distance = 999;
      distance = sqrt((food[i].posx-newpos[0])*(food[i].posx-newpos[0])+(food[i].posy-newpos[1])*(food[i].posy-newpos[1]));
      if (distance < (food[i].size+size)/2) {
        SLength+=food[i].value;
        food[i].reset();
      }
    }
    //testSnake
    for(int i=0;i<SLength;i++){
      float distance = 999;
      distance = sqrt((snake.pos[i][0]-newpos[0])*(snake.pos[i][0]-newpos[0])+(snake.pos[i][1]-newpos[1])*(snake.pos[i][1]-newpos[1]));
      if (distance < size/2) {
        print(SLength + "    " + startLength + "\n");
        dead = true;
      }
    }
    //testBlocks
    for(Blocks b : blocks){
      float distance = 999;
      distance = sqrt((b.pos[0]+b.size/2-newpos[0])*(b.pos[0]+b.size/2-newpos[0])+(b.pos[1]+b.size/2-newpos[1])*(b.pos[1]+b.size/2-newpos[1]));
      if (distance < (size+b.size*sqrt(2))/2 ) {
        dead = true;
      }
    }
  }

  /***************************************
   *Updates the Snake Body and Head
   ***************************************/
  void updateSnake() {
    for (int i=SLength; i>0; i--) {
      pos[i][0] = pos[i-1][0];
      pos[i][1] = pos[i-1][1];
    }
    pos[0][0] = newpos[0];
    pos[0][1] = newpos[1];

    size=byte(9.6+round((0.1)*sqrt(SLength)));
    FieldSize = size*0.7;
  }
  
}
