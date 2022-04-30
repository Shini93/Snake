/*********************************
 *Global variables
 *ToDO: Add special after x runs through portal
 *TODO: Add special Portal to go to next level after minimum requirement?
 *********************************/
byte GameSpeed =30;            //sets fps

byte MaxPortals = 3;            //Maximum Portals in the game
byte NumberPlayer = 1;
byte activeSnake = 0;
//byte rectcorner = 0;

int directionKey = 0;           //0 == no change, -1 = left, 1 = right
int maxRays = 720;              //Maximum number of Rays for the Raycasting
int marginX = 0;
int marginY = 0;
int WorldSizeX = width;
int WorldSizeY = height;
//int StepMovingBlock = 0;



int maxFood = 0;                //maximum food collected
int maxLevel = 1;              //highest level reached
int SnakeNormalColor = 0;
int GridSize = 100;
int MaxGrids = 0;
int SnakeColorSelected = 0;
int[] mousepos = {0,0};

Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
Snake[] snake = new Snake[NumberPlayer];      //Snek
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();  //Chanes levels as needed
Math math = new Math();
GUIController Menu, lvlSettings, backHandler, ShopHandler;
IFButton start, settings, levelsetting, back, shop, s_back, s_forward, buy, backShop;
IFButton[] levels = new IFButton [100];
DataHandler datahandler = new DataHandler();
movingTiles movingtiles;

String BuyText = "buy";
color[] SnakeColor = {#AAFFFF , #FF7E80, #FF7EF0, #917EFF, #7EC0FF, #7EFFB9, #A4FF7E, #FFFB7E, #FFB27E, #FFFFFF};


boolean shopmenu = false;
boolean GameStart = false;
boolean isAndroid = false;
boolean[] deactivateButton = new boolean[3];
boolean[] boughtItems = new boolean[SnakeColor.length];

ArrayList<Food> food = new ArrayList <Food>();  //Spawns Food
ArrayList <Blocks> blocks = new ArrayList <Blocks>();
ArrayList <Special> specials = new ArrayList <Special>();
ArrayList<GridSystem> grid = new ArrayList <GridSystem>();  //Spawns Food

float AndroidAngle = 0;
float ScaleScreenX = 1;
float ScaleScreenY = 1;

PImage[] img = new PImage[100];
PImage imgLock;
PGraphics SnakeGraphic;
