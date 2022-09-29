/*********************************
 *Global variables
 *ToDO: Add special after x runs through portal
 *TODO: Add special Portal to go to next level after minimum requirement?
 *********************************/
byte GameSpeed = 30;            //sets fps
byte MaxPortals = 3;            //Maximum Portals in the game
byte NumberPlayer = 1;
byte activeSnake = 0;
byte maxMTiles = 0;

int directionKey = 0;           //0 == no change, -1 = left, 1 = right
int maxRays = 720;              //Maximum number of Rays for the Raycasting
int marginX = 0;
int marginY = 0;
int WorldSizeX = 1920;
int WorldSizeY = 1080;
int sizeFont = 30;
int maxFood = 0;                //maximum food collected
int maxLevel = 1;              //highest level reached
int SnakeNormalColor = 0;
int GridSize = 100;
int MaxGrids = 0;
int SnakeColorSelected = 0;
int[] mousepos = {0,0};
int[][][] DLines = new int[20][30][4];

Portal[] portal = new Portal[MaxPortals];  //creates Portal Array, filled in in lvl file.
Snake[] snake = new Snake[NumberPlayer];      //Snek
Level lvl = new Level();        //has all the lvls in it
lvlHandler lvls = new lvlHandler();  //Chanes levels as needed
Math math = new Math();
Button[] levels = new Button [100];
Button start,levelsetting, shop, settings,back,s_back, s_forward, buy, backShop;
DataHandler datahandler = new DataHandler();
movingTiles[] movingtiles = new movingTiles[10];

String BuyText = "buy";
color[] SnakeColor = {#AAFFFF , #FF7E80, #FF7EF0, #917EFF, #7EC0FF, #7EFFB9, #A4FF7E, #FFFB7E, #FFB27E, #FFFFFF};
color[] colorscheme = {#AAAAAA , #FFAAAA, #BBFFBB, #AAAAFF};
color BackgroundColor = #200000;

boolean shopmenu = false;
boolean GameStart = false;
boolean isAndroid = false;
boolean[] deactivateButton = new boolean[3];
boolean[] boughtItems = new boolean[SnakeColor.length];
boolean shaderOn = false;

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
