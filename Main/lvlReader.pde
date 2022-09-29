class lvlReader {
  lvlReader() {
  }

  int[][] readData() {
    String path = "level/Lvl"+lvls.actualLevel+".txt";
    if(isAndroid == false)
      path = "/"+path;
    BufferedReader reader = createReader(path);
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
          if (i+1<pieces.length() && pieces.charAt(i+1)=='#') {
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
    if(allPoint.size()>0){
        maxMTiles=0;
        boolean out = false;
        int start = 0;
        int count = -1;
        while(out == false){
          BlockPos[k][0] = allPoint.get(start);
          BlockPos[k][1] = allPoint.get(start+1);
          k++;
          boolean innerout = false;
          int z=0;
          int[][] movingBlocks = new int[20][2];
          int i=start;
          innerout = false; 
          while(innerout == false){
            movingBlocks[z][0] = allPoint.get(i)+15;
            movingBlocks[z][1] = allPoint.get(i+1)+15;
            z++;
            boolean test = i>start;
            if((i>start && abs(allPoint.get(i) - allPoint.get(start))==0) && abs(allPoint.get(i+1) - allPoint.get(start+1))==0){
              start = i+2;
              innerout = true;
            }
            if( i>=allPoint.size()-2){
             out = true; 
             innerout = true; 
            }
            i+=2;
          }
          count++;
          maxMTiles++;
          movingtiles[count] = new movingTiles(count,movingBlocks);
        } //<>//
    }
    return BlockPos;
  }
  
  /***************************
  *Read latest level from file
  ****************************/
  byte getlatestLevel() {
    if(isAndroid == false){
     //we'll have a look in the data folder
    java.io.File folder = new java.io.File(dataPath("/level"));

    // list the files in the data folder
    String[] filenames = folder.list();

    return byte(filenames.length);
    }else
      return byte(1);      //implement function for android to find out how many lvl there are implemented!
  }
}
