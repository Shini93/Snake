/*********************************
 *Global variables
 *ToDO: Add special after x runs through portal
 *TODO: Add special Portal to go to next level after minimum requirement?
 *********************************/

//Einstellbar
boolean isAndroid = false;
byte GameSpeed = 30;            //sets fps
byte NumberPlayer = 1;
int GridSize = 500;
color[] SnakeColor = {#AAFFFF , #FF7E80, #FF7EF0, #917EFF, #7EC0FF, #7EFFB9, #A4FF7E, #FFFB7E, #FFB27E, #FFFFFF};
color[] colorscheme = {#AAAAAA , #FFAAAA, #BBFFBB, #AAAAFF};
color BackgroundColor = #222222;
boolean shaderOn = false;

//----------------------------------------------------------------------------------
//needed by program
byte MaxPortals = 40;            //Maximum Portals in the game
byte activeSnake = 0;
byte maxMTiles = 0;

int directionKey = 0;           //0 == no change, -1 = left, 1 = right
PVector worldSize;
int sizeFont = 30;
int maxFood = 0;                //maximum food collected
int maxLevel = 1;              //highest level reached
int SnakeNormalColor = 0;
int MaxGrids = 0;
int SnakeColorSelected = 0;
PVector mousepos = new PVector(0,0);
int[][][] DLines = new int[20][30][4];      //x,y,z   x: number possible linecombos; y: number possible lines; z: coordinates for 1 line x1,y1, x2,y2
int[] boughtUpgrades = {0,0,0,0,0,0,0};  //superSpeed, Number Rockets, number mini Snakes, amplitude&Frequency mini Snakes, upgrades processed faster, further sight, borader sight
int dWidth;
int dHeight;

Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
Snake[] snake = new Snake[NumberPlayer];      //Snek
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();  //Chanes levels as needed
Math math = new Math();
Button androidSpeed, androidRocket;
DataHandler datahandler = new DataHandler();
movingTiles[] movingtiles = new movingTiles[10];
GUIPage[] guiPages = new GUIPage[5];
SoundFile[] guiSound = new SoundFile[2];    //hover, click
SoundFile[] gameSound = new SoundFile[1];    //food

String BuyText = "buy";          //alles shopmenu mäiges in eine klasse packen, statt in globals!
String[] GUINames = {"Main","Level","Shop","Settings","Won"};

boolean shopmenu = false;
boolean GameStart = false;
boolean gamePause = false;

boolean[] boughtItems = new boolean[SnakeColor.length];
boolean androidSpeedOn = false;

ArrayList<Food> food = new ArrayList <Food>();  //Spawns Food
ArrayList <Blocks> blocks = new ArrayList <Blocks>();
ArrayList <Special> specials = new ArrayList <Special>();
ArrayList<GridSystem> grid = new ArrayList <GridSystem>();  //Spawns Food

float AndroidAngle = 0;
float ScaleScreenX = 1;
float ScaleScreenY = 1;
float Zoom = 1;

PShader myShader;
PShader FoodShader;

PImage[] img = new PImage[100];
PImage[] i_Food = new PImage[8];            //Food images Dimm,Bright; RGBY
PImage imgLock;

PGraphics SnakeGraphic;
PGraphics pg_Lines;
