//TODO: Blöcke für lvl 1 noch erstellen!!!!
class Level {
  byte maxFood = 0;
  byte maxLvl = 5;
  boolean setPortal = false;
  int blocksize = 0;
  Level() {

  }

  void callBlocks(byte level,int[][] pos) {
    maxFood = 100;
    int[] x = new int [pos.length/2+1];
    int[] y = new int [pos.length/2+1];
    for (int i=0; i<pos.length/2+1; i++) {
      x[i]=pos[i][0];
      y[i]=pos[i][1];
    }
    AddPortal(new int[]{50,50,750,750,200,200,500,500});
    for (int i=0; i<maxFood; i++) {
      food.add(new Food(i, 1, i*10, i%5*10));
    }
    blocksize = pos.length;
    snake.pos[0][0] = 150;
    snake.pos[0][1] = 150;
    fillBlocks(x,y);
  }
  void fillBlocks(int[] x, int[] y){
    for (int i=0; i<=blocksize/2; i++) {
      blocks.add(new Blocks(i, x[i], y[i])); //<>//
    } 
  }
  void AddPortal(int[] posport){
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
