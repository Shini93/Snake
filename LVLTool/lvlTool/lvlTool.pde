/*************** //<>// //<>//
 *Global
 ***************/
//Add fodfunction ->green,blue,yellow,red
//Add Portal (1 and 2)
ArrayList <Integer> blocksx = new ArrayList<Integer>();
ArrayList <Integer> blocksy = new ArrayList<Integer>();
int ImouseX = mouseX;
int ImouseY = mouseY;

int[] snake = new int[2];
int[][] BlockLine = new int[1000][2];
int[][] Tele = new int[1000][2];
int[][] Food = new int[1000][2];
int scale = 30;            //rastersize
int timer = 0;             
int chosenLevel = 0;       //level to see
int maxMovingLine = 0;       //
int maxPortal = 0;      //Portal
int maxFood = 0;      //Portal
int countMirror = 0;

boolean MirrorOn = false;
boolean Mousepressed = false;
boolean lvlloaded, willDraw = false;      //willdraw: save image
byte switchKey = 0;

String Mode = "Blocks";          //chosenMode

FileHandler filehandler = new FileHandler();
PGraphics noLines;

void setup() {
  fullScreen(1);
  background(125);
  noLines = createGraphics(width, height);
  chosenLevel = filehandler.getlatestLevel()+1;
  
  /*Init arrays*/
  for (int i=0; i<1000; i++) {              //Blocklines to 0
    for (int j=0; j<2; j++) {              //Blocklines to 0
      BlockLine[i][j] = -10;
      Tele[i][j] = -10;
      Food[i][j] = -10;
    }
  }
}
void BlocksFood(){
  addBlock();    //adds Block to Array
  
  addFood();    //adds Block to Array
  
}
void draw() {
  ImouseX = mouseX;
  ImouseY = mouseY;
  background(125);
  resetScreen();
  drawLines();
  
  BlocksFood();
  
  if(MirrorOn == true){
    ImouseX = width-mouseX;
    BlocksFood();
    ImouseY = height - mouseY;
    BlocksFood();
    ImouseX = mouseX;
    BlocksFood();
  }
  drawBlock();      //draws on screen
  drawFood();      //draws on screen 
  
  addMovingBlock();
  drawMovingTiles();
  addTele();
  drawTele();
  image(noLines, 0, 0);

  if (willDraw == false) {
    noLines.textSize(25);
    noLines.fill(0);
    noLines.text("P: print Blocks \nZ: undo Blocks \nR: reverse Blocks\nD+Click: delete hovered Block \nS: saves the blocks to a local file \nL: changes level\nNumberBlocks: "+blocksx.size()+"\nMode: "+Mode+"\nchosenLevel: "+chosenLevel+ "\n Mirror: "+MirrorOn, 0, 30);
  }
  willDraw = false;
  noLines.endDraw();
  image(noLines, 0, 0);
  
}

void resetScreen() {
  noLines.beginDraw();
  noLines.clear();
  noLines.fill(#FFFFFF);
}

void drawLines(){
  fill(0);
  strokeWeight(1);
  line(0, mouseY, width, mouseY);
  line(mouseX, 0, mouseX, height);
  strokeWeight(3);
  line(width/2,0,width/2,height);
  line(0,height/2,width,height/2);
  strokeWeight(1);
  stroke(100);
  for(int i=0;i<round(width/scale);i++){
    line(i*scale,0,i*scale,height);
  }
  for(int i=0;i<round(width/scale);i++){
    line(0,i*scale,width,i*scale);
  }
  stroke(0);
}
