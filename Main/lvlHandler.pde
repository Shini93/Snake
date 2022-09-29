/*******************
*Handles the levels
*******************/
class lvlHandler{
  lvlReader reader = new lvlReader();        //Reads the actual level from the file
  byte actualLevel = 1;                      //defaultlevel
  byte Killcount = 0;                        //default deaths
  byte lvlSelect = -1;                       //default lvl select
  lvlHandler(){
    
  }
  
  /****************
  *lvl finished
  *saves progress
  ****************/
  void victory(){
    if(snake[0].SLength>=lvl.winsize){            //when snake has a set size, the level is won.
       if(actualLevel >= lvl.maxLvl){             //nothing happens if highest lvl is reached.
         return;
       }
       actualLevel++;
       if(actualLevel > maxLevel)
         maxLevel++;                              //maximum reached lvl updated
       deactivateButton[0] = false;
       datahandler.savetoJson();                  //saves to file
       reset();                                   //resets all states
       GameStart = false;
    }
  }
  
  /*********************
  *starts start lvl
  *fills lvl with Blocks
  **********************/
  void start(){
    lvl.maxLvl = reader.getlatestLevel();
    //reader.readData();
    if(lvlSelect == -1)
      lvl.callBlocks(byte(actualLevel),reader.readData());                 //starts at lvl 1
    else{
      actualLevel = lvlSelect;
      lvl.callBlocks(byte(lvlSelect),reader.readData()); 
    }
  }
  
  /***** gets last unlocked level *****/
  void getLatestLevel(){
   lvl.maxLvl = reader.getlatestLevel(); 
  }
  
  /****** resets the level to load a new one ******/
  void reset(){
    food.clear();
    for(int i=0;i<snake.length;i++){
      snake[i] = new Snake(false, int(random(800)), int(random(800)),i);
    }
    blocks.clear();
    specials.clear();
    lvl.count=1;
    for(Snake s : snake){
      s.missile = new Missiles();
    }
    portal = new Portal[MaxPortals];
    lvl.setPortal = false;
    Killcount++;
    //StepMovingBlock = 0;
    for ( int i=0; i<3;i++)
      if(movingtiles[i] != null)
        movingtiles[i].reset();
    SetupSnake();
  }
  
  void setlvl(byte level){
    lvl.callBlocks(level,reader.readData()); //<>//
  }
  
}
