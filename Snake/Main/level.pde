//TODO: Blöcke für lvl 1 noch erstellen!!!!




class Level{
  byte maxLvl = 10;
  byte maxBlocks = 10;
  int [][][] Blocks = new int[maxLvl][maxBlocks][2];
   Level(){
     
   }
  
  void callBlocks(byte level){
    switch (level){
      case 1:
        for(int i=0;i<10;i++){
          Blocks[1][i][0] = 90+BlockSize*(1+2*i); 
          Blocks[1][i][1] = height/2-BlockSize;
        }
        for (int i=0; i<maxFood; i++) {
          food[i] = new Food(i, 1, i*10,i%5*10);
        }
    }
      
    for(int i =0; i<maxBlocks; i++){
        blocks[i] = new Blocks(i,2,3);
        blocks[i].pos[0] = Blocks[level][i][0];
        blocks[i].pos[1] = Blocks[level][i][1];
        
    }
  }
   
    
  }
