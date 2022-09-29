class FileHandler{
  
 
  FileHandler(){}
  
  void savetoFile(){
    
    int level = getlatestLevel()+1;
    if(lvlloaded == true){
      level = chosenLevel;
    }

    PrintWriter output = createWriter("../../Main/data/level/Lvl"+level+".txt");
    String out = width+";\n"+height+"\n!"+snake[0]+";"+snake[1]+";~";
    for(int i=0;i<blocksx.size();i++){          //blocks
      out = out+blocksx.get(i)+";"+blocksy.get(i)+";\n";
    }
    out +="#";
    if(chosenPoint >0){
      for(int i=0;i<chosenPoint;i++){          //blocksLine
        out = out+BlockLine[i][0]+";"+BlockLine[i][1]+";\n";
      }
    }
    output.write(out);
    output.flush();
    output.close();
    BufferedReader reader = createReader("../../Main/data/level/Lvl"+getlatestLevel()+".txt");
    String line = null;
    try {
      while ((line = reader.readLine()) != null) {
        String pieces = line;
        print(pieces);
      }
      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  
  int getlatestLevel(){
    // we'll have a look in the data folder
    java.io.File folder = new java.io.File(dataPath("../../../Main/data/level"));
    
    // list the files in the data folder
    String[] filenames = folder.list();
  
    // display the filenames
    for (int i = 0; i < filenames.length; i++) {
      println(filenames[i]);
    }
    return filenames.length;
  }
  int[][] readData() {
    BufferedReader reader = createReader("../../../Main/data/level/Lvl"+chosenLevel+".txt");
    String line = null;
    String pieces = "";
    ArrayList <Integer> allPos = new ArrayList <Integer>();
    try {
      while ((line = reader.readLine()) != null) {
        pieces += line;
      }
      boolean counterStart = false;
      boolean SnakeFinish = false;
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
          while (pieces.charAt(i)!=';' && pieces.charAt(i) != '#') {
            Number += pieces.charAt(i);
            i++;
          }
          allPos.add(int(Number));
        }
      }

      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    int BlockPos[][] = new int[allPos.size()][2];
    int k=0;
    for (int i=0; i<allPos.size()-1; i+=2) {
      BlockPos[k][0] = allPos.get(i);
      BlockPos[k][1] = allPos.get(i+1);
      k++;
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
