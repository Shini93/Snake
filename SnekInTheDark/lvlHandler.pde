/******************* //<>// //<>// //<>// //<>// //<>//
 *Handles the levels
 *******************/
class lvlHandler {
  lvlReader reader = new lvlReader();        //Reads the actual level from the file
  byte Killcount = 0;                        //default deaths
  byte lvlSelect = -1;                       //default lvl select
  lvlHandler() {
  }

  /****************
   *lvl finished
   *saves progress
   ****************/
  boolean victory() {
    //log.append("levelHandler.victory");
    if (snake[0].SLength>=lvl.winsize) {            //when snake has a set size, the level is won.
      music.stop();
      datahandler.savetoJson(getJsonPath());
      if (actualLevel < maxReachedLvl) {             //nothing happens if highest lvl is reached.
        return true;
      }
      maxReachedLvl++;                              //maximum reached lvl updated
      actualLevel++;
      //resetToMainScreen();
      datahandler.savetoJson(getJsonPath());
      return true;
    }
    return false;
  }

  void resetToMainScreen() {
    //log.append("levelHandler.resetToMainScreen");
    datahandler.savetoJson(getJsonPath());                  //saves to file
    reset();                                   //resets all states
    GameStart = false;
    music.stop();
    shopmenu = false;
    background(BackgroundColor);
    initButtonsStartScreen();
  }

  /*********************
   *starts start lvl
   *fills lvl with Blocks
   **********************/
  void start() {
    //log.append("levelHandler.start");
    maximumDesignLvl = reader.getlatestLevel();
    
    if (lvlSelect != -1) {
      actualLevel = lvlSelect;
    }
    
    lvl.callBlocks(byte(actualLevel), reader.readData());                 //starts at lvl 1
    
    int soundTrack = actualLevel % 5;
    if(isAndroid)
      soundTrack = actualLevel % 2;
    initMusic(soundTrack);
  }

  /***** gets last unlocked level *****/
  void getLatestLevel() {
    //log.append("levelHandler.getLatestLevel");
    maximumDesignLvl = reader.getlatestLevel();
  }

  /****** resets the level to load a new one ******/
  void reset() {
    //log.append("levelHandler.reset");
    music.stop();
    BackgroundColor = #222222;
    food.clear();
    for (int i=0; i<snake.length; i++) {
      snake[i].body = new ArrayList <SnakeBody>();
      snake[i] = new Snake(false, int(random(800)), int(random(800)), i);
    }
    blocks.clear();
    specials.clear();
    lvl.count=1;
    for (Snake s : snake) {
      s.missile = new Missiles();
    }
    portal = new Portal[MaxPortals];
    lvl.setPortal = false;
    Killcount++;
    grid.clear();
    laternen.clear();
    //StepMovingBlock = 0;
    movingtiles = new movingTiles[10];
    SetupSnake();
  }

  void setlvl(byte level) {
    //log.append("levelHandler.setlvl");
    lvl.callBlocks(level, reader.readData());
  }
}
