//TODO: Blöcke für lvl 1 noch erstellen!!!!
class Level {
  byte maxFood = 1;
  byte maxLvl = 1;
  boolean setPortal = false;
  int blocksize = 0;
  int winsize = 40;
  Level() {

  }

  void callBlocks(byte level,int[][] pos) {
    for (int i=0; i<100; i++) {
      food.add(new Food(i, round(random(1)), round(random(width)), round(random(height))));
    }
    switch (level){
      case 1:
        food.clear();
        maxFood = 16;
        snake.pos[0][0] = pos[0][0];
        snake.pos[0][1] = pos[0][1];
        for (int i=0; i<maxFood/2; i++) {
          food.add(new Food(i, 1, 110, 60+i*80));
          food.add(new Food(i*8, 1, 700, 160+i*80));
        }
        winsize = 20+maxFood*5;
        AddPortal(new int[]{50,50,770,750});
        break;  
      case 2:
        food.clear();
        maxFood = 16;
        snake.pos[0][0] = pos[0][0];
        snake.pos[0][1] = pos[0][1];
        for (int i=0; i<maxFood/2; i++) {
          food.add(new Food(i, 1, 110, 60+i*80));
          food.add(new Food(i*8, 1, 700, 160+i*80));
        }
        winsize = 20+maxFood*5;
        break;  
      
    }
    
    int[] x = new int [pos.length/2+1];
    int[] y = new int [pos.length/2+1];
    for (int i=1; i<pos.length/2+1; i++) {
      x[i]=pos[i][0];
      y[i]=pos[i][1];
    }
    //AddPortal(new int[]{50,50,750,750,200,200,500,500});
    blocksize = pos.length;
    fillBlocks(x,y);
  }
  
  
  void fillBlocks(int[] x, int[] y){
    for (int i=1; i<=blocksize/2-1; i++) {
      blocks.add(new Blocks(i, x[i], y[i]));
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
