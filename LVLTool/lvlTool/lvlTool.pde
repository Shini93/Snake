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

PVector World = new PVector(1920*2,1080*2);

byte MirrorOn = 4;
boolean Mousepressed = false;
boolean lvlloaded, willDraw = false;      //willdraw: save image
boolean newInput = false;
byte switchKey = 0;

String Mode = "Blocks";          //chosenMode
String MirrorName[] = {"xy-Achse","y-Achse","180°-gespiegelt","x-Achse","normal"};

FileHandler filehandler = new FileHandler();
PGraphics noLines;
float scaleFact = 1;

void setup() {
  fullScreen(1);
  //scaleFact = (min(width/World.x,height/World.y));
  World.x = round(width/scaleFact);
  World.y = round(height/scaleFact);
  //size(300,300);
  background(125);
  textSize(25);
  noLines = createGraphics(round(World.x), round(World.y));
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

void mirrorEntities(){
  if(MirrorOn == 0){
    ImouseX = round(World.x- (  mouseX / scaleFact));
    BlocksFood();
    ImouseY = round(World.y - (mouseY / scaleFact));
    BlocksFood();
    ImouseX = round(mouseX/scaleFact);
    BlocksFood();
  }
  else if(MirrorOn == 1){
    ImouseX = round(World.x- (  mouseX / scaleFact));
    BlocksFood();
  }
  else if(MirrorOn == 2){
    ImouseX = round(World.x- (  mouseX / scaleFact));
    ImouseY = round(World.y - (mouseY / scaleFact));
    BlocksFood();
  }
  else if(MirrorOn == 3){
    ImouseY = round(World.y - (mouseY / scaleFact));
    ImouseX = round(mouseX/scaleFact);
    BlocksFood();
  }
}

void draw() {
  if(newInput == false)
    return;
  background(125);
  resetScreen();
  ImouseX = round(mouseX/scaleFact);
  ImouseY = round(mouseY/scaleFact);
  drawLines();
  
  BlocksFood();
  mirrorEntities();
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
    text("P: print Blocks \nZ: undo Blocks \nR: reverse Blocks\nD+Click: delete hovered Block \nS: saves the blocks to a local file \nL: changes level\nNumberBlocks: "
      +blocksx.size()+"\nMode: "
      +Mode+"\nchosenLevel: "
      +chosenLevel+ "\n M: Mirror: "
      +MirrorName[MirrorOn]+"\n +- Zoom"+"\n Width = "
      +World.x+"   height = "+World.y, 0, 30);
  }
  willDraw = false;
  noLines.endDraw();
  image(noLines, 0, 0);
  if(mousePressed == false)
    newInput = false;
  
}

void resetScreen() {
  noLines.beginDraw();
  noLines.clear();
  noLines.fill(#FFFFFF);
}

void drawLines(){
  fill(0);
  strokeWeight(1);
  //waagerechte linie
  line(0, mouseY, round(width), mouseY);
  //senkrechte Linie
  line(mouseX, 0, mouseX, round(height));
  strokeWeight(3);
  //Fadenkreuz Mitte Bildschirm
  line(round(width)/2,0,round(width)/2,round(height));
  line(0,round(height)/2,round(width),round(height)/2);
  strokeWeight(1);
  stroke(100);
  for(int i=0;i<ceil(round(World.x)/scale)+1;i++){
    line(i*scale*scaleFact,0,i*scale*scaleFact,round(height));
  }
  for(int i=0;i<ceil(round(World.y)/scale)+1;i++){
    line(0,i*scale*scaleFact,round(width),i*scale*scaleFact);
  }
  stroke(0);
}

void resetAll(){
  blocksx.clear();
  blocksy.clear();
  maxMovingLine = 0;       //
  maxPortal = 0;      //Portal
  maxFood = 0;      //Portal
}
