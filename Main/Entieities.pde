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
  int posx;            
  int posy;
  int BGcolour;
  int colour = color(#FFFFFF);
  int value;                     //How much a snake grows when eating it
  boolean outofBounds = true;    //out of sight from Screen
  
  /********************************
   *Overloaded constructor
   ********************************/
  Food(int aid, int foodkind) {
    id = aid;
    FoodKind = foodkind;
    posx = int(random(WorldSizeX-2*GridSize-2*marginX))+GridSize;
    posy = int(random(WorldSizeY-2*GridSize-2*marginY))+GridSize;
    init();
  }
  Food(int aid, int foodkind, int x, int y) {
    id = aid;
    FoodKind = foodkind;
    posx = x;
    posy = y;
    init();
  }
  
  /**************************************
  *resets the Food and respawns it
  **************************************/
  void reset() {
    Boolean overlap = true;            //Must not be inside a block
    while(overlap){
      overlap = false;
      posx = int(random(WorldSizeX-2*GridSize-2*marginX))+GridSize;
      posy = int(random(WorldSizeY-2*GridSize-2*marginY))+GridSize;
      for(int i=0;i<blocks.size()-1;i++){
        if(posx>blocks.get(i).pos[0] && posx<blocks.get(i).pos[0]+blocks.get(i).size){
          if(posy>blocks.get(i).pos[1] && posy<blocks.get(i).pos[1]+blocks.get(i).size){
            overlap = true;
            break;
          }
        }
      }
    }
    FoodKind=round(random(11));
    if (FoodKind == 11)
      FoodKind = 2;
    else
      FoodKind = round(FoodKind/10);
    init();
  }
  
  /**************************************
  *defines the parameters
  **************************************/
  void init () {
    colour = color(#FFFFFF);
    if (FoodKind == 0) {
      size = 5;
      normalSize = 5;
      BGcolour = color(#00FF00);
      value = 1;
    } else if (FoodKind ==1) {
      size = 10;
      normalSize = 10;
      BGcolour = color(#0000FF);
      value = 5;
    } else {
      size = 15;
      normalSize = 15;
      BGcolour = color(#FFFF00);
      value = 0;                    //Adds Special after some time
    }
  }
}

/****************************
*Block class
*Blocks defined in lvl system
*****************************/
class Blocks{
  int[] pos = new int[2];    //x,y position
  color colour = 255;          //startcolor is black
  int size = 30;
  int id;
  boolean RayCast = false;
  boolean outofBounds = true;
  int fade = 0;
  
  Blocks(int ida, int x, int y){ //overloaded constructor
    pos[0] = x;
    pos[1] = y;
    id = ida;                //Block ID not implemented yet
  }
  
  Blocks(int ida){            //overloaded constructor
    id = ida;
  }
  
  void reset() {              //has to be changed to positions on the grid.
    pos[0] = round(random(width-2*marginX)/30)*30;
    pos[1] = round(random(height-2*marginY)/30)*30;
  }
}


class movingTiles{
  int blockID;
  int[][] Path = new int[20][2];
  int StepMovingBlock=0;
  byte rectcorner = 0;
  byte maxCorner = 0;
  
  movingTiles(int id, int[][] PATH ){
    blockID = id;
    Path = PATH;
    while(PATH[i][0] > -1)
      maxCorner++;
  }
  void reset(){
    rectcorner=0;
    StepMovingBlock=0;
  }
}
