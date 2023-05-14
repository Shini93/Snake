class FileHandler { //<>// //<>// //<>// //<>//
  FileHandler() {
  }
  String saveBlocks(String out) {
    out+=";~";
    for (int i=0; i<blocksx.size(); i++) {          //blocks
      out = out+blocksx.get(i)+";"+blocksy.get(i)+";\n";
    }
    return out;
  }
  String saveMoving(String out) {
    out +="#";
    if (maxMovingLine >0) {
      for (int i=0; i<maxMovingLine; i++) {          //blocksLine
        out = out+BlockLine[i][0]+";"+BlockLine[i][1]+";\n";
      }
    }
    return out;
  }
  String savePortal(String out) {
    out+="y";
    for (int i=0; i<maxPortal; i++) {          //Portal
      out = out+Tele[i][0]+";"+Tele[i][1]+";\n";
      println(maxPortal);
    }
    return out;
  }
  String saveFood(String out) {
    out+="x";
    for (int i=0; i<maxFood; i++) {          //Portal
      out = out+Food[i][0]+";"+Food[i][1]+";\n";
      println(maxFood);
    }
    return out;
  }
  void savetoFile() {      //size;~blocks;#movingTiles;xPortal;yFoodNormal%FoodBig

    int level = getlatestLevel()+1;
    if (lvlloaded == true) {
      level = chosenLevel;
    }

    PrintWriter output = createWriter("../../Main/Main/data/level/Lvl"+level+".txt");
    String out = World.x+";\n"+World.y+"\n;!"+snake[0]+";"+snake[1]+"";
    out = saveBlocks(out);
    out = saveMoving(out);
    out = saveFood(out);
    out = savePortal(out);
    output.write(out);
    output.flush();
    output.close();
    BufferedReader reader = createReader("../../Main/Main/data/level/Lvl"+getlatestLevel()+".txt");
    String line = null;
    try {
      while ((line = reader.readLine()) != null) {
        String pieces = line;
        print(pieces);
      }
      reader.close();
      chosenLevel++;
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  int getlatestLevel() {
    // we'll have a look in the data folder
    java.io.File folder = new java.io.File(dataPath("../../../Main/Main/data/level"));

    // list the files in the data folder
    String[] filenames = folder.list();

    // display the filenames
    if (filenames != null) {
      for (int i = 0; i < filenames.length; i++) {
        println(filenames[i]);
      }

      return filenames.length;
    }
    return 0;
  }
  //Update for all new elements (copy from snake)
  //int[][] readData() {
  //  BufferedReader reader = createReader("../../../Main/Main/data/level/Lvl"+chosenLevel+".txt");
  //  String line = null;
  //  String pieces = "";
  //  ArrayList <Integer> allPos = new ArrayList <Integer>();
  //  try {
  //    while ((line = reader.readLine()) != null) {
  //      pieces += line;
  //    }
  //    boolean counterStart = false;
  //    boolean SnakeFinish = false;
  //    for (int i=0; i<pieces.length(); i++) {
  //      if (pieces.charAt(i)=='!' && SnakeFinish == false) {      //starts with x seperated from ;
  //        i++;
  //        counterStart = true;
  //      }
  //      if (pieces.charAt(i)=='~') {      //starts with x seperated from ;
  //        SnakeFinish = true;
  //        i++;
  //        counterStart = true;
  //      }
  //      if (counterStart) {
  //        String Number = "";
  //        while (pieces.charAt(i)!=';' && pieces.charAt(i) != '#') {
  //          Number += pieces.charAt(i);
  //          i++;
  //        }
  //        allPos.add(int(Number));
  //      }
  //    }

  //    reader.close();
  //  }
  //  catch (IOException e) {
  //    e.printStackTrace();
  //  }

  //  int BlockPos[][] = new int[allPos.size()][2];
  //  int k=0;
  //  for (int i=0; i<allPos.size()-1; i+=2) {
  //    BlockPos[k][0] = allPos.get(i);
  //    BlockPos[k][1] = allPos.get(i+1);
  //    k++;
  //  }
  //  return BlockPos;
  //}

  int[][] readData() {
    String path = "/../../../Main/Main/data/level/Lvl"+chosenLevel+".txt";
    BufferedReader reader = createReader(path);
    String line = null;
    String pieces = "";
    ArrayList <Integer> allPos = new ArrayList <Integer>();
    ArrayList <Integer> allPoint = new ArrayList <Integer>();
    try {
      while ((line = reader.readLine()) != null) {
        pieces += line;
      }
      maxPortal = 0;
      maxFood = 0;
      char lastSpecialChar = ' ';
      /*read out the data*/
      for (int i=0; i<pieces.length(); i++) {
        if (pieces.charAt(i)=='!' || pieces.charAt(i)=='~' || pieces.charAt(i)=='#' || pieces.charAt(i)=='x' || pieces.charAt(i)=='y') {
          lastSpecialChar = pieces.charAt(i);
        } else {
          ArrayList <Integer> dummyList = new ArrayList <Integer>();
          while (i<pieces.length()-1 && (pieces.charAt(i)!='!' && pieces.charAt(i)!='~' && pieces.charAt(i)!='#' && pieces.charAt(i)!='x' && pieces.charAt(i)!='y')) {
            String Number = "";
            while (pieces.charAt(i)!=';') {
              Number += pieces.charAt(i);
              i++;
            }
            if (i<pieces.length()-1)
              i++;
            dummyList.add(int(Number));
          }
          if (lastSpecialChar == ' ') {
            scaleFact =  width / float(dummyList.get(0));
            World.x = round(width/scaleFact);
            World.y = round(height/scaleFact);
           // noLines = createGraphics(round(World.x), round(World.y));
            println(scaleFact);
          }
          if (lastSpecialChar == '!') {
            allPos = dummyList;
          } else if (lastSpecialChar == '~') {
            for (int j=0; j<dummyList.size(); j++)
              allPos.add(int(dummyList.get(j)));
          } else if (lastSpecialChar == '#') {
            allPoint = dummyList;
          } else if (lastSpecialChar == 'x') {
            for (int j=0; j<dummyList.size(); j+=2) {
              Food[maxFood][0] = dummyList.get(j);
              Food[maxFood][1] = dummyList.get(j+1);
              maxFood++;
            }
          } else if (lastSpecialChar == 'y') {
            for (int j=0; j<dummyList.size(); j+=2) {
              Tele[maxPortal][0] = dummyList.get(j);
              Tele[maxPortal][1] = dummyList.get(j+1);
              maxPortal++;
            }
          }
          lastSpecialChar = pieces.charAt(i);
        }
      }

      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    //scaleFact = width/pieces.
    int BlockPos[][] = new int[allPos.size()+3][2];
    int k=0;
    for (int i=0; i<allPos.size(); i+=2) {
      BlockPos[k][0] = allPos.get(i);
      BlockPos[k][1] = allPos.get(i+1);
      k++;
    }
    if (allPoint.size()>0) {
      boolean out = false;
      int start = 0;
      while (out == false) {
        BlockPos[k][0] = allPoint.get(start);
        BlockPos[k][1] = allPoint.get(start+1);
        k++;
        boolean innerout = false;
        int i=start;
        innerout = false;
        while (innerout == false) {
          BlockLine[maxMovingLine][0] = allPoint.get(i)+15;
          BlockLine[maxMovingLine][1]  = allPoint.get(i+1)+15;
          maxMovingLine++;
          if ((i>start && abs(allPoint.get(i) - allPoint.get(start))==0) && abs(allPoint.get(i+1) - allPoint.get(start+1))==0) {
            start = i+2;
            innerout = true;
          }
          if ( i>=allPoint.size()-2) {
            out = true;
            innerout = true;
          }
          i+=2;
        }
      }
    }
    return BlockPos;
  }

  void callBlocks(int[][] pos) {
    snake[0] = pos[0][0];
    snake[1] = pos[0][1];

    int[] x = new int [pos.length/2+1];
    int[] y = new int [pos.length/2+1];
    for (int i=1; i<pos.length/2+1; i++) {
      x[i]=pos[i][0];
      y[i]=pos[i][1];
    }
    int blocksize = pos.length;
    blocksx.clear();
    blocksy.clear();
    for (int i=1; i<=blocksize/2-1; i++) {
      blocksx.add(x[i]);
      blocksy.add(y[i]);
    }
  }
}
