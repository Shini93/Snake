/******************************************
 *Handles all about Snakes
 ******************************************/
class Snake {
  /***************************************
   *Public Variables
   ***************************************/
  float Angle = PI/2; //Angle of moving
  float oldAngle;  //Angle from one iteration before
  byte size = 10;  //startsize of the Snake
  color colour = color(#00FFFF);  //Colour of the Snake
  float FieldSize = 7;            //Startsize of each Snakesegment
  int MaxLength = 1000;          //maximum length of snake
  int pos[][] = new int [MaxLength][2]; //  [Head][x,y]
  int newpos[] = new int[2];
  int startLength = 20;
  int SLength = startLength;
  boolean dead = false;
  int portaltime = 0;
  int wallteletime = 0;
  /***************************************
   *Constructor
   ***************************************/
  Snake() {
    pos[0][0] = width/2;
    pos[0][1] = height/100;
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
    oldAngle = Angle;
    if(mouseX-pmouseX!=0 && mouseY-pmouseY!=0)  //snake moves always in the same direction
      Angle = Anglecalc(pos[0][0],pos[0][1],mouseX,mouseY);

    newpos[0] = int(pos[0][0]+FieldSize*sin(Angle));
    newpos[1] = int(pos[0][1]-FieldSize*cos(Angle));
  }

  /***************************************
   *Tests if the Path is free
   ***************************************/
  void testPath() {
    testFood();
    testSnake();
    testBlocks();    
    testPortal();  
    testWalls();
  }

  /***************************************
   *Updates the Snake Body and Head
   ***************************************/
  void updateSnake() {
    for (int i=SLength; i>0; i--) {
      pos[i][0] = pos[i-1][0];
      pos[i][1] = pos[i-1][1];
    }
    pos[0][0] = int(newpos[0]);
    pos[0][1] = int(newpos[1]);

    size=byte(9.6+round((0.15)*sqrt(SLength)));
    FieldSize = size*0.7;
  }
  
  void teleport(int x, int y){
     newpos[0] = x;
     newpos[1] = y;
  }
  
  void testFood(){
   //TestFood
    for (int i=0; i<maxFood; i++) {
      float distance = 999;
      distance = sqrt((food[i].posx-newpos[0])*(food[i].posx-newpos[0])+(food[i].posy-newpos[1])*(food[i].posy-newpos[1]));
      if (distance < (food[i].size+size)/2) {
        SLength+=food[i].value;
        food[i].reset();
      }
    } 
  }
  void testSnake(){
   //testSnake
    for(int i=0;i<SLength;i++){
      float distance = 999;
      distance = sqrt((snake.pos[i][0]-newpos[0])*(snake.pos[i][0]-newpos[0])+(snake.pos[i][1]-newpos[1])*(snake.pos[i][1]-newpos[1]));
      if (distance < size/2) {
        print(SLength + "    " + startLength + "\n");
        dead = true;
      }
    } 
  }
  void testBlocks(){
   //testBlocks
    for(Blocks b : blocks){
        if(newpos[0]+size/2>=b.pos[0] && newpos[0]-size/2 <= b.pos[0] + b.size && newpos[1]+size/2>=b.pos[1] && newpos[1] -size/2 <= b.pos[1] + b.size){
        dead = true;
      }
    } 
  }
  void testWalls(){
    //testWalls
    if(wallteletime > 2){
      if(snake.pos[0][0] <= 0 || snake.pos[0][1] <= 0 || snake.pos[0][0] >= width || snake.pos[0][1] >= height){
        if(snake.pos[0][0] <=0){
          teleport(width,snake.pos[0][1]);
          wallteletime=0;
        }
        if(snake.pos[0][1] <=0){
          teleport(snake.pos[0][0],height); 
          wallteletime=0;
        }
        if(snake.pos[0][0] >=width){
          teleport(0,snake.pos[0][1]); 
          wallteletime=0;
        }
        if(snake.pos[0][1] >= height){
          teleport(snake.pos[0][0],0);  
          wallteletime=0;
        }
      }
    }
    if(wallteletime <=2)
      wallteletime ++;
  }
  
  void testPortal(){
  //testPortal
    if(portaltime > 20){
      for(Portal p : portal){
        float[] distance = new float[2];
        boolean teleported = false;
        for(int i=0;i<2;i++){
          if(teleported==false){
            distance[i] = abs(distance(p.pos[i][0], p.pos[i][1],newpos[0],newpos[1]));
            if (distance[i] < (size+p.size*sqrt(2))/2 ) {
              if(newpos[0]+size/2 > p.pos[i][0]-p.size/4 && newpos[0]-size/2 <= p.pos[i][0]+p.size/4 && newpos[1]+size/2 > p.pos[i][1]-p.size/2 && newpos[1]-size/2 <= p.pos[i][1]+p.size/2){
                teleport(p.pos[1-i][0],p.pos[1-i][1]);
                portaltime = 0;
                teleported = true;
              }
            }
          }
        }
      }
    }
    if(portaltime <=20)
      portaltime ++;
  }
}
