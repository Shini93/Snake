class lvlHandler{
  lvlReader reader = new lvlReader();
  byte actualLevel = 1;
  byte Killcount = 0;
  byte lvlSelect = -1;
  lvlHandler(){
    
  }
  void victory(){
    if(snake.SLength>=lvl.winsize){ //<>//
       if(actualLevel < lvl.maxLvl){ //<>//
         actualLevel++; //<>//
         if(actualLevel > maxLevel)
           maxLevel++; //<>//
         deactivateButton[0] = false; //<>//
         datahandler.savetoJson(); //<>//
         reset(); //<>//
         GameStart = false;
         Menu.setVisible(true);
         
        // datahandler.savetoFile("maxFood",str(maxFood));
       }
    }
  }
  void start(){
    lvl.maxLvl = reader.getlatestLevel();
    //reader.readData();
    if(lvlSelect == -1)
      lvl.callBlocks(byte(actualLevel),reader.readData());                 //starts at lvl 1 //<>//
    else{
      actualLevel = lvlSelect;
      lvl.callBlocks(byte(lvlSelect),reader.readData());  //<>// //<>//
    }
  }
  void getLatestLevel(){
   lvl.maxLvl = reader.getlatestLevel(); 
  }
  void reset(){
 //   reader = new lvlReader();
    food.clear();
    snake = new Snake();
    path = new MissilePath[100];
    blocks.clear();
    lvl.blocksize=0;
    missile = new Missiles();
    portal = new Portal[MaxPortals];
    lvl.setPortal = false;
    Killcount++;
    SetupSnake();
  }
  
  void setlvl(byte level){
    lvl.callBlocks(level,reader.readData());
  }
  
}
