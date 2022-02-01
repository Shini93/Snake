class lvlReader{
 lvlReader(){
   
 }
 
 int[][] readData(){
  BufferedReader reader = createReader("../LVLTool/lvlTool/data/Lvl"+lvls.actualLevel+".txt");
  String line = null;
  String pieces = "";
  ArrayList <Integer> allPos = new ArrayList <Integer>(); 
  try {
    while ((line = reader.readLine()) != null) {
      pieces += line;
    }
    boolean counterStart = false;
    boolean SnakeFinish = false;
    for(int i=0;i<pieces.length();i++){
      if(pieces.charAt(i)=='!' && SnakeFinish == false){      //starts with x seperated from ;
        i++;
        counterStart = true;
      }
      if(pieces.charAt(i)=='~'){      //starts with x seperated from ;
        SnakeFinish = true;
        i++;
        counterStart = true;
      }
      if(counterStart){
        String Number = "";
        while(pieces.charAt(i)!=';'){
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
  for(int i=0;i<allPos.size();i+=2){
    BlockPos[k][0] = allPos.get(i);
    BlockPos[k][1] = allPos.get(i+1);
    k++;
  }
  return BlockPos;
 }
 
  byte getlatestLevel(){
  // we'll have a look in the data folder
  java.io.File folder = new java.io.File(dataPath("../../LVLTool/lvlTool/data/"));
  
  // list the files in the data folder
  String[] filenames = folder.list();

  // display the filenames
  for (int i = 0; i < filenames.length; i++) {
    println(filenames[i]);
  }
  return byte(filenames.length);
}
 
}
