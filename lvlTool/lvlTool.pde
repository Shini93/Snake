/***************
 *Global
 ***************/
ArrayList <Integer> blocksx = new ArrayList<Integer>();
ArrayList <Integer> blocksy = new ArrayList<Integer>();
int[] snake = new int[2];
int scale = 30;
boolean Mousepressed = false;
int timer = 0;
byte switchKey = 0;
String Mode = "Blocks";
int chosenLevel = 0;
FileHandler filehandler = new FileHandler();
boolean lvlloaded,willDraw = false;

void setup() {
  size(800, 800);
  background(125);
}

void draw() {
  fill(125);
  rect(0, 0, 800, 800);
  fill(#FFFFFF);
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
      rect(blocksx.get(i), blocksy.get(i), scale, scale);
    }
      fill(#00FFFF);
      circle(snake[0],snake[1],10);
      fill(#FFFFFF);
  }
  if(willDraw == false){
    textSize(25);
    fill(0);
    text("P: print Blocks \nZ: undo Blocks \nR: reverse Blocks\nD+Click: delete hovered Block \nS: saves the blocks to a local file \nNumberBlocks: "+blocksx.size()+"\nMode: "+Mode+"\nchosenLevel: "+chosenLevel, 0, 30);
  }
  willDraw = false;
}

void mousePressed() {
  Mousepressed = !Mousepressed;
  if(Mode == "Snake"){
     snake[0] = mouseX;
     snake[1] = mouseY;
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
    else if(switchKey == 3){
      Mode = "Portals";
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
