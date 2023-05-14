//TODO: Blöcke für lvl 1 noch erstellen!!!!
class Level {
  byte maxFood = 1;
  byte maxLvl = 1;
  boolean setPortal = false;
  int blocksize = 0;
  int winsize = 1000;
  int count=1;
  Level() {

  }

  void callBlocks(byte level,int[][] pos) {
    snake[0].body.get(0).pos = new PVector(pos[0][0],pos[0][1]);
    winsize = round( 0.1 * worldSize.x) + 5 * ceil( level * 2.0) - 50;    //winsize higher every 5 level, or level size incease
      
    count = pos.length;
    int[] x = new int [count];
    int[] y = new int [count];
    for (int i=1; i<=count-1; i++) {
      x[i]=pos[i][0];
      y[i]=pos[i][1];
    }
    blocksize = count;
    println("callblocks");
    fillBlocks(x,y);
  }
  
  
  void fillBlocks(int[] x, int[] y){
    for (int i=1; i<=x.length-1; i++) {
      blocks.add(new Blocks(i, x[i], y[i]));
    } 
  }
  
  void AddPortal(int[] posport){ //<>//
    for(byte i=0;i<posport.length/4;i++){
      int[] portdummy = new int[4];
      for(byte c = 0;c<4;c++)
        portdummy[c] = posport[4*i+c];
      portal[i] = new Portal(portdummy);
    }
    setPortal = true;
    MaxPortals = byte(posport.length/4);
  }
}
