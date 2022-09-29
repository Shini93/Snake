/***************
 *Global
 ***************/
ArrayList <Integer> blocksx = new ArrayList<Integer>();
ArrayList <Integer> blocksy = new ArrayList<Integer>();
int[] snake = new int[2];
int[][] BlockLine = new int[1000][2];
int scale = 30;
boolean Mousepressed = false;
int timer = 0;
byte switchKey = 0;
String Mode = "Blocks";
int chosenLevel = 0;
FileHandler filehandler = new FileHandler();
boolean lvlloaded,willDraw = false;
int chosenPoint = 0;
PGraphics noLines;

void setup() {
  fullScreen(1);
  background(125);
  noLines = createGraphics(width,height);
  for(int i=0;i<100;i++){
    BlockLine[i][0] = -10;
    BlockLine[i][1] = -10;
  }
  
}

void draw() {
  background(125);
  
  noLines.beginDraw();
  noLines.clear();
  noLines.fill(125);
  noLines.rect(0, 0, width, height);
  noLines.fill(#FFFFFF);
  if (Mousepressed && Mode == "Blocks") {
    int xscaled = 0;
    int yscaled = mouseY;
    xscaled = round(mouseX/scale)*scale;
    yscaled = round(mouseY/scale)*scale;
    boolean exists = false;
    for (int i=blocksx.size()-1; i>=0; i--) {
      if (blocksx.size() > 0 && blocksx.get(i) == xscaled && blocksy.get(i) == yscaled) {
        exists = true;
        if (keyPressed && key=='d') {
          blocksx.remove(i);
          blocksy.remove(i);
        }
      }
    }
    
    if (exists == false && keyPressed==false) {
      blocksx.add(xscaled);
      blocksy.add(yscaled);
    }
  }
  for (int i=0; i<blocksx.size(); i++) {
    {
      noLines.rect(blocksx.get(i), blocksy.get(i), scale, scale);
    }
      noLines.fill(#00FFFF);
      noLines.circle(snake[0],snake[1],10);
      noLines.fill(#FFFFFF);
  }
  if (Mode == "movingBlockLine") {
    int xscaled = 0;
    int yscaled = 0;
    xscaled = round(((mouseX+scale/2)/scale))*scale;
    yscaled = round(((mouseY+scale/2)/scale))*scale;
    noLines.circle(xscaled,yscaled,5);
  }
  int start = 0;
  if(chosenPoint > 10){
   println("meh");  //<>//
  }
  
  
  for(int i=0;i<chosenPoint-1;i++){
    boolean startfound = false;
    noLines.stroke(0);
    if(i>start && BlockLine[i][0] == BlockLine[start][0] && BlockLine[i][1] == BlockLine[start][1]){
      start = i+1;
      startfound = true;
    }
    if(BlockLine[0][0] != -10 && startfound == false)
      noLines.line(BlockLine[i][0],BlockLine[i][1],BlockLine[i+1][0],BlockLine[i+1][1]);
  }
  image(noLines,0,0);
  
  if(willDraw == false){
    noLines.textSize(25);
    noLines.fill(0);
    noLines.text("P: print Blocks \nZ: undo Blocks \nR: reverse Blocks\nD+Click: delete hovered Block \nS: saves the blocks to a local file \nL: changes level\nNumberBlocks: "+blocksx.size()+"\nMode: "+Mode+"\nchosenLevel: "+chosenLevel, 0, 30);
  }
  willDraw = false;
  noLines.endDraw();
  image(noLines,0,0);
  fill(0);
  line(0,mouseY,width,mouseY);
  line(mouseX,0,mouseX,height);
}

void mousePressed() {
  Mousepressed = !Mousepressed;
  if(Mode == "Snake"){
     snake[0] = mouseX;
     snake[1] = mouseY;
  }
  else if(Mode == "movingBlockLine"){
    int xscaled = 0;
    int yscaled = 0;
    xscaled = round((mouseX+scale/2)/scale)*scale;
    yscaled = round((mouseY+scale/2)/scale)*scale;
     BlockLine[chosenPoint][0] = xscaled;
     BlockLine[chosenPoint][1] = yscaled;
     chosenPoint++;
  }
}
void mouseReleased() {
  Mousepressed = !Mousepressed;
}
void keyPressed() {
  if (key =='p' || key == 'P') {             //print current blocks to console.
    print("\nx:\n"+blocksx);
    print("\ny:\n"+blocksy);
  } else if (key =='z' || key == 'Z') {      //Undo last move
    blocksx.remove(blocksx.size()-1);
    blocksy.remove(blocksy.size()-1);
  } else if (key =='r' || key == 'R') {      //reverse Blocks
    ReverseBlocks();
  } else if (key =='S' || key == 's') {      //saves to file
    filehandler.savetoFile();
    createImage();
  }  
  else if (key ==TAB) {      //saves to file
    switchKey++;            //0:Blocks, 1:Snake, 2: Food, 3: Portals
    if(switchKey ==0)
      Mode = "Blocks";
    else if(switchKey ==1)
      Mode = "Snake";
    else if(switchKey ==2)
      Mode = "Food";
    else if(switchKey == 3)
      Mode = "Portals";
    else if(switchKey == 4){
      Mode = "movingBlockLine";
      switchKey = -1;
    }
    
  }else if (key =='l' || key == 'L') {      //saves to file
    chosenLevel=1+chosenLevel%int(filehandler.getlatestLevel()); //<>//
    filehandler.callBlocks(filehandler.readData());
    lvlloaded = true;
  }
}


void ReverseBlocks(){
 ArrayList <Integer> dummyX = new ArrayList<Integer>();
  ArrayList <Integer> dummyY = new ArrayList<Integer>();
  for (int i=0; i<width/scale+1; i++) {
    for (int k=0; k<height/scale+1; k++) {
      boolean exists = false;
      for (int j=0; j<blocksy.size(); j++) {
        if ( round((i)*scale) == blocksx.get(j) && round((k)*scale) == blocksy.get(j)) {
          exists = true;
        }
      }
      if (exists == false) {
        dummyX.add(round((i)*scale));
        dummyY.add(round((k)*scale));
      }
    }
  }
  blocksx = dummyX;
  blocksy = dummyY; 
}
