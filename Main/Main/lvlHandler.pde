/******************* //<>//
 *Handles the levels
 *******************/
class lvlHandler {
  lvlReader reader = new lvlReader();        //Reads the actual level from the file
  byte actualLevel = 1;                      //defaultlevel
  byte Killcount = 0;                        //default deaths
  byte lvlSelect = -1;                       //default lvl select
  lvlHandler() {
  }

  /****************
   *lvl finished
   *saves progress
   ****************/
  boolean victory() {
    if (snake[0].SLength>=lvl.winsize) {            //when snake has a set size, the level is won.
      if (actualLevel >= lvl.maxLvl) {             //nothing happens if highest lvl is reached.
        return true;
      }
      actualLevel++;
      if (actualLevel > maxLevel)
        maxLevel++;                              //maximum reached lvl updated
      resetToMainScreen();
      return true;
    }
    return false;
  }

  void resetToMainScreen() {

    datahandler.savetoJson();                  //saves to file
    reset();                                   //resets all states
    GameStart = false;

    shopmenu = false;
    background(BackgroundColor);
    initButtonsStartScreen();
  }

  /*********************
   *starts start lvl
   *fills lvl with Blocks
   **********************/
  void start() {
    lvl.maxLvl = reader.getlatestLevel();
    //reader.readData();
    if (lvlSelect == -1) {
      lvl.callBlocks(byte(actualLevel), reader.readData());                 //starts at lvl 1
    } else {
      actualLevel = lvlSelect;
      lvl.callBlocks(byte(lvlSelect), reader.readData());  
    }
  }

  /***** gets last unlocked level *****/
  void getLatestLevel() {
    lvl.maxLvl = reader.getlatestLevel();
  }

  /****** resets the level to load a new one ******/
  void reset() {
    BackgroundColor = #222222;
    food.clear();
    for (int i=0; i<snake.length; i++) {
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
    //StepMovingBlock = 0;
    movingtiles = new movingTiles[10];
    SetupSnake();
  }

  void setlvl(byte level) {
    lvl.callBlocks(level, reader.readData());
  }
}
