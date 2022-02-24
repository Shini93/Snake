class PrimalSnake{
   /***************************************
   *Public Variables
   ***************************************/
  float Angle = PI/2; //Angle of moving
  float oldAngle;  //Angle from one iteration before
  byte size = 10;  //startsize of the Snake
  float FieldSize = 7;            //Startsize of each Snakesegment
  int MaxLength = 1000;          //maximum length of snake
  //int pos[][] = new int [MaxLength][2]; //  [Head][x,y]
  color colour = #00FFFF;  //Colour of the Snake
  int newpos[] = new int[2];
  int startLength = 20;
  int SLength = startLength;
  boolean dead = false;
  boolean NPC = false;
  int portaltime = 0;
  int wallteletime = 0;
  ArrayList <SnakeBody> body = new ArrayList <SnakeBody>();
  
  
  /*****************************************
   *Returns colour of Snakebody on given pos
   *****************************************/
  color BodyColour(int bodypart){
    return color(bodypart*red(SnakeColor[SnakeColorSelected])/SLength,bodypart*green(SnakeColor[SnakeColorSelected])/SLength,bodypart*blue(SnakeColor[SnakeColorSelected])/SLength); 
  }
  
  /***************************************
   *Moves the Snake
   ***************************************/
  void move() {    //moves snake one step in direction of angle
    nextTile();    //Moves onto next tile
    testPath();    //Tests if food, enemy, boarder, oder lvl up is on the way
    updateSnake();  //Updates snake body
  }
  
  void testPath(){
    testFood();
    testBlocks();     
    testWalls();
  }
  void testBlocks(){
    
    
  }
  
  void testWalls(){
    //testWalls
    if(wallteletime > 2){
      if(body.get(0).pos[0] <= marginX || body.get(0).pos[1] <= marginY || body.get(0).pos[0] >= width-2*marginX || body.get(0).pos[1] >= height-2*marginY){
        if(body.get(0).pos[0] <=0){
          teleport(width-2*marginX,body.get(0).pos[1]);
          wallteletime=0;
        }
        if(body.get(0).pos[1] <=0){
          teleport(body.get(0).pos[0],height-2*marginY); 
          wallteletime=0;
        }
        if(body.get(0).pos[0] >=width-2*marginX){
          teleport(0,body.get(0).pos[1]); 
          wallteletime=0;
        }
        if(body.get(0).pos[1] >= height-2*marginY){
          teleport(body.get(0).pos[0],0);  
          wallteletime=0;
        }
      }
    }
    if(wallteletime <=2)
      wallteletime ++;
  }
  
  void testFood(){
   //TestFood
    for (int i=0; i<food.size(); i++) {
      float distance = 999;
      distance = sqrt((food.get(i).posx-newpos[0])*(food.get(i).posx-newpos[0])+(food.get(i).posy-newpos[1])*(food.get(i).posy-newpos[1]));
      if (distance < (food.get(i).size+size)/2) {
        for(int k=0;k<food.get(i).value;k++)
          body.add(new SnakeBody(15,15));
        SLength+=food.get(i).value;
        maxFood+=food.get(i).value;
        food.get(i).reset();
      }
    } 
  }
  
  /***************************************
   *Finds out the next tile for the Head
   ***************************************/
  void nextTile() {
    int NewDirectionX = mouseX-marginX;
    int NewDirectionY = mouseY-marginY;
    
    oldAngle = Anglecalc(body.get(0).pos[0],body.get(0).pos[1],-body.get(5).pos[0],-body.get(5).pos[1]);
    
    if(NPC == true){
      Angle = oldAngle+random(PI/10)-PI/20;
      if(millis()%10 == 0 || millis()%11 == 0 || millis()%12 == 0)
        Angle = oldAngle+random(PI/2)-PI/4;
    }
    else if(NPC == false){
      if(mouseX-pmouseX!=0 && mouseY-pmouseY!=0)  //snake moves always in the same direction
        Angle = Anglecalc(body.get(0).pos[0],body.get(0).pos[1],NewDirectionX,NewDirectionY);
    }
 //   float Anglediff = min((2 * PI) - abs(Angle - oldAngle), abs(Angle - oldAngle));

    newpos[0] = int(body.get(0).pos[0]+FieldSize*sin(Angle));
    newpos[1] = int(body.get(0).pos[1]-FieldSize*cos(Angle));
  }
  
  
  /***************************************
   *Updates the Snake Body and Head
   ***************************************/
  void updateSnake() {
    for (int i=SLength-1; i>0; i--) {
      body.get(i).pos[0] = body.get(i-1).pos[0];
      body.get(i).pos[1] = body.get(i-1).pos[1];
    }
    body.get(0).pos[0] = int(newpos[0]);
    body.get(0).pos[1] = int(newpos[1]);

    size=byte(9.6+round((0.15)*sqrt(SLength)));
    FieldSize = size*0.7;
  }
  
  void teleport(int x, int y){
     newpos[0] = x;
     newpos[1] = y;
  }
  
  
}
