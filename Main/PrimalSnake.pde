class PrimalSnake{
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
      if(body.get(0).pos[0] <= marginX || body.get(0).pos[1] <= marginY || body.get(0).pos[0] >= WorldSizeX-2*marginX || body.get(0).pos[1] >= WorldSizeY-2*marginY){
        if(body.get(0).pos[0] <=0){
          teleport(WorldSizeX-2*marginX,body.get(0).pos[1]);
          wallteletime=0;
        }
        if(body.get(0).pos[1] <=0){
          teleport(body.get(0).pos[0],WorldSizeY-2*marginY); 
          wallteletime=0;
        }
        if(body.get(0).pos[0] >=WorldSizeX-2*marginX){
          teleport(0,body.get(0).pos[1]); 
          wallteletime=0;
        }
        if(body.get(0).pos[1] >= WorldSizeY-2*marginY){
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
          body.add(new SnakeBody(body.get(body.size()-3).pos[0],body.get(body.size()-3).pos[1]));
        if(food.get(i).value == 0){     //Upgrade to be made

        }else{
          SLength+=food.get(i).value;
          maxFood+=food.get(i).value;
          food.get(i).reset();
          fillGridsFood();
          DrawFood();
        }
        
      }
    } 
  }
  
  /***************************************
   *Finds out the next tile for the Head
   ***************************************/
  void nextTile() {

    int NewDirectionX = 0;
    int NewDirectionY = 0;

    //oldAngle = Anglecalc(body.get(1).pos[0],body.get(1).pos[1],body.get(0).pos[0],body.get(0).pos[1]);
 
    if(NPC == true){
      //Angle = 2*PI*noise(0.001*millis());
      if(targetFood == -1)
        targetFood = round(random(food.size()));
      if(dist(body.get(0).pos[0],food.get(targetFood).posx,body.get(0).pos[1],food.get(targetFood).posy) <= size)
        targetFood = round(random(food.size()));
      float AngleFood = math.Anglecalc(body.get(0).pos[0],body.get(0).pos[1],food.get(targetFood).posx,food.get(targetFood).posy);
      Angle = AngleFood;
    }
    else if(NPC == false){
      if(isAndroid == false){
       // if(mouseX-pmouseX!=0 && mouseY-pmouseY!=0)  //snake moves always in the same direction
         if(id == 0){
          NewDirectionX = round(mouseX/ScaleScreenX+body.get(0).pos[0]-width/2);
          NewDirectionY = round(mouseY/ScaleScreenY+body.get(0).pos[1]-height/2);
          Angle = math.Anglecalc(body.get(0).pos[0],body.get(0).pos[1],NewDirectionX,NewDirectionY);
         }
          else if (id == 1){
           Angle = oldAngle + PI/15 * directionKey;
           if(Angle > 2*PI)
             Angle = Angle - 2*PI;
           else if (Angle<0)
             Angle = Angle + 2*PI;
         }
      }
      else{
       Angle = AndroidAngle;  
      }
      Angle = math.AngleResize(Angle,oldAngle);
      
    }
   
    newpos[0] = round(body.get(0).pos[0]-FieldSize*speedSnake*math.cosAlike(Angle));
    newpos[1] = round(body.get(0).pos[1]-FieldSize*speedSnake*math.sinAlike(Angle));
    
    oldAngle = Angle;
  }
  
  
  /***************************************
   *Updates the Snake Body and Head
   ***************************************/
  void updateSnake() {
    for (int i=SLength; i>0; i--) {
      body.get(i).pos[0] = body.get(i-1).pos[0];
      body.get(i).pos[1] = body.get(i-1).pos[1];
    }

    
    body.get(0).pos[0] = (newpos[0]);
    body.get(0).pos[1] = (newpos[1]);

    Calcsize();
    FieldSize = size*0.7;   
  }
  
  void teleport(int x, int y){
     newpos[0] = x;
     newpos[1] = y;
  }
  
  void Calcsize(){
   size=byte(9.6+round((0.15)*sqrt(SLength)));  
  }
  
}
