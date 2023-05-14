/******** for Android only!!!**********///<>// //<>//
//import android.os.Environment;
//import android.os.Build ;
//import android.app.Activity;
//import android.content.Context;

//Activity activity ;
//Context context ;
/**************************************/

class lvlReader {
  lvlReader() {
  }


  int[][] readData() {
    String path = "level/Lvl"+lvls.actualLevel+".txt";
    if (isAndroid == true)
      path = ""+path;
    BufferedReader reader = createReader(path);
    String line = null;
    String pieces = "";
    ArrayList <Integer> allPos = new ArrayList <Integer>();
    ArrayList <Integer> allPoint = new ArrayList <Integer>();
    try {
      while ((line = reader.readLine()) != null) {
        pieces += line;
      }
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
          
          //get World Size
          getWorldSize(lastSpecialChar, dummyList);
          
          //get snake position
          if (lastSpecialChar == '!') {
            allPos = dummyList;
            snake[0].body.get(0).pos = new PVector(dummyList.get(0), dummyList.get(1));
            
            //get normal Blocks
          } else if (lastSpecialChar == '~') {
            for (int j=0; j<dummyList.size(); j++)
              allPos.add(int(dummyList.get(j)));
              
              //get moving lines
          } else if (lastSpecialChar == '#') {
            allPoint = dummyList;
            
            //get foods
          } else if (lastSpecialChar == 'x') {
            for (int j=0; j<dummyList.size(); j+=2) {
              food.add(new Food(round(j/2), 1, dummyList.get(j), dummyList.get(j+1)));
            }
            
            //get Portals
          } else if (lastSpecialChar == 'y') {
            int[] dummy = new int[dummyList.size()];
            for (int j=0; j<dummyList.size(); j++) {
              dummy[j] = dummyList.get(j);
              if(j % 2 == 0)
                dummy[j] += 5;
              else
                dummy[j] += 10;
            }
            lvl.AddPortal(dummy);
          }
          lastSpecialChar = pieces.charAt(i);
        }
      }

      reader.close();
      println("reader worked");
    }
    catch (IOException e) {
      e.printStackTrace();
    }

    int BlockPos[][] = new int[allPos.size()/2][2];
    int k=0;
    for (int i=0; i<allPos.size(); i+=2) {
      BlockPos[k][0] = allPos.get(i);
      BlockPos[k][1] = allPos.get(i+1);
      k++;
    }

    if (allPoint.size()<=0)
      return BlockPos;

    int dummy[][] = new int[30][2];
    for (int i=0; i<30; i++) {
      dummy[i][0] = -1;
      dummy[i][1] = -1;
    }
    maxMTiles=0;
    boolean out = false;
    int start = 0;
    int count = -1;

    //gets moving blocks
    while (out == false) {
      //Moving block start position
      dummy[count+1][0] = allPoint.get(start)-15;
      dummy[count+1][1] = allPoint.get(start+1)-15;
      k++;
      boolean innerout = false;
      int z=0;
      int[][] movingBlocks = new int[200][2];
      int i=start;
      innerout = false;
      while (innerout == false) {
        //only dotted line, NOT block start pos
        movingBlocks[z][0] = allPoint.get(i)+15;
        movingBlocks[z][1] = allPoint.get(i+1)+15;
        z++;
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
      count++;
      maxMTiles++;
      movingtiles[count] = new movingTiles(count, movingBlocks);
    }
    int[][] dummy2 = BlockPos;
    BlockPos = new int[allPos.size()/2+count+1][2];
    for (int i=0; i<dummy2.length; i++) {
      BlockPos[i][0] = dummy2[i][0];
      BlockPos[i][1] = dummy2[i][1];
    }
    for (int i=0; i<count+1; i++) {
      BlockPos[i+allPos.size()/2][0] = dummy[i][0];
      BlockPos[i+allPos.size()/2][1] = dummy[i][1];
    }

    return BlockPos;
  }

  /***************************
   *Read latest level from file
   ****************************/
  byte getlatestLevel() {
    if (isAndroid == false) {
      //we'll have a look in the data folder
      java.io.File folder = new java.io.File(dataPath("/level"));

      // list the files in the data folder
      String[] filenames = folder.list();

      return byte(filenames.length);
    } else {
      return byte(19);
    }
  }
}

void getWorldSize(char lastSpecialChar, ArrayList <Integer> dummyList) {
  if (lastSpecialChar != ' ')
    return;
  worldSize.x = dummyList.get(0);
  worldSize.y = dummyList.get(1);
}
