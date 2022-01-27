class lvlHandler{
  lvlReader reader = new lvlReader();
  byte actualLevel = 1;
  byte Killcount = 0;
  lvlHandler(){
    
  }
  void victory(){
    if(snake.SLength>=25){
       if(actualLevel < lvl.maxLvl){
         actualLevel++;
         reset();
       }
    }
  }
  void start(){
    reader.readData();
    lvl.callBlocks(byte(actualLevel),reader.readData());                 //starts at lvl 1
  }
  void reset(){
    reader = new lvlReader();
    food.clear();
    snake = new Snake();
    path = new MissilePath[100];
    blocks.clear();
    lvl.blocksize=0;
    missile = new Missiles();
    portal = new Portal[MaxPortals];
    setup();
    Killcount++;
  }
  
  void setlvl(byte level){
    lvl.callBlocks(level,reader.readData());
  }
}
