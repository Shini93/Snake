class lvlReader {
  lvlReader() {
  }

  int[][] readData() {
    BufferedReader reader = createReader("/level/Lvl"+lvls.actualLevel+".txt");
    String line = null;
    String pieces = "";
    ArrayList <Integer> allPos = new ArrayList <Integer>();
    ArrayList <Integer> allPoint = new ArrayList <Integer>();
    try {
      while ((line = reader.readLine()) != null) {
        pieces += line;
      }
      boolean counterStart = false;
      boolean SnakeFinish = false;
      boolean countblockP = false;
      for (int i=0; i<pieces.length(); i++) {
        if (pieces.charAt(i)=='!' && SnakeFinish == false) {      //starts with x seperated from ;
          i++;
          counterStart = true;
        }
        if (pieces.charAt(i)=='~') {      //starts with x seperated from ;
          SnakeFinish = true;
          i++;
          counterStart = true;
        }
        if (counterStart) {
          String Number = "";
          while (pieces.charAt(i)!=';') {
            Number += pieces.charAt(i);
            i++;
          }
          allPos.add(int(Number));
        }
        if (pieces.charAt(i+1)=='#') {
          countblockP = true;
          counterStart = false;
          i+=2;
        }
        if(countblockP == true){
         String Number = "";
          while (pieces.charAt(i)!=';') {
            Number += pieces.charAt(i);
            i++;
          }
          allPoint.add(int(Number)); 
        }
      }
      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    int BlockPos[][] = new int[allPos.size()+3][2];
    int k=0;
    for (int i=0; i<allPos.size(); i+=2) {
      BlockPos[k][0] = allPos.get(i);
      BlockPos[k][1] = allPos.get(i+1);
      k++;
    }
    
      BlockPos[k][0] = allPoint.get(0);
      BlockPos[k][1] = allPoint.get(1);
    
    int z=0;
    int[][] movingBlocks = new int[10][2];
    for (int i=0; i<allPoint.size(); i+=2) {
      movingBlocks[z][0] = allPoint.get(i)+30;
      movingBlocks[z][1] = allPoint.get(i+1)+15;
      z++;
    }
    movingtiles = new movingTiles(0,movingBlocks);
    return BlockPos;
  }

  byte getlatestLevel() {
    // we'll have a look in the data folder
    java.io.File folder = new java.io.File(dataPath("/level"));

    // list the files in the data folder
    String[] filenames = folder.list();

    return byte(filenames.length);
  }
}
