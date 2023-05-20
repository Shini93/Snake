//TODO: Modus wo alle x secunden y schlangenteile sterben, der letzte gewinnt //<>// //<>// //<>//
//TODO: alle x futter, wird ein giftiges ausgekackt, was einen teile nimmt, zersetzt sich nach einiger Zeit

//import processing.javafx.*;

/***********************************
 *TODO:
 *grafik erstellen, was mit was zusammenhängt und wie oft?
 *auf android lauffähig machen
 *videos aufnehmen beim Programmieren
 nullpointer on different machine?
 *make draw functions in lvl function as lvl.draw?
 **********************************/

//Unten links und unten rechts werden die bilder sehr spät eingeblendet
import processing.sound.*;

void setup() {
  fullScreen(P2D,1);
  //size(400,1200,P2D);
  //size(1920,1280,P2D);
  if (isAndroid == false) {
    dWidth = width;
    dHeight = height;
  } else {
    dWidth = width;
    dHeight = height;

    androidSpeed = new Button(dWidth-200, dHeight-200, 100, 100, "speed");
    androidSpeed.addImage("img/speed.png");
    androidRocket = new Button(dWidth-100, dHeight-100, 100, 100, "rocket");
    androidRocket.addImage("img/special_rocket.png");
  }
  
  initSounds();

  for (int i=0; i < guiPages.length; i++) {
    guiPages[i] = new GUIPage(GUINames[i]);
  }
  guiPages[0].active = true;
  guiPages[4].addButton(0.2*width, 0.5*height, 0.6*width, 0.05*height, "VICTORYYYY \nDo you want to keep playing?");
  guiPages[4].addButton(0.2*width, 0.7*height, 0.2*width, 0.05*height, "Absolutely");
  guiPages[4].addButton(0.6*width, 0.7*height, 0.2*width, 0.05*height, "Nah I'm fine");

  sizeFont = round( dHeight / 20 );
  worldSize = new PVector(dWidth, dHeight);
  background(BackgroundColor);     //color of interface background
  MaxGrids = ceil(worldSize.x*(worldSize.y)/(GridSize*GridSize))+1;    //Sets the maximum grid size
  PFont myFont = createFont("Laksaman Bold", sizeFont, true);  //Sets font to be used in the game
  textFont(myFont);

  initButtonsStartScreen();      //Adds starting Buttons
  //datahandler.savetoJson();
  datahandler.readJson();      //reads variables from json like food eaten and snakes bought
  datahandler.savetoJson();
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*************************************
 *Initialises program
 *************************************/
void SetupSnake() {
  for (int i=0; i<NumberPlayer; i++) {    //Adds Snakes played from player
    snake[i] = new Snake(false, int(random(800)), int(random(800)), i);
  }

  setupMulti();                            //Sets up Multiplayer screen
  lvls.start();                            //starts the first level
  setupGrid();
  SnakeGraphic = createGraphics(int(worldSize.x), int(worldSize.y), P2D);    //creates canvas on which all will be drawn on
  drawMovingTilesLines();

  frameRate(GameSpeed);                    //sets the gamespeed to 30 fps
  if (shaderOn == true) {
    myShader = loadShader("data/shader/Block_shader.frag");
    myShader.set("resolution", float(dWidth), float(dHeight));

    FoodShader = loadShader("data/shader/Food_Shader.frag");
    FoodShader.set("resolution", float(dWidth), float(dHeight));
  } else {
    String[] FoodNames = {"RedBright.png", "RedBright.png", "GreenDimm.png", "GreenBright.png", "BlueDimm.png", "BlueBright.png", "GoldDimm.png", "GoldBright.png"};
    for (int i = 0; i < 8; i ++)
      i_Food[i] = loadImage("img/"+FoodNames[i]);        //foodimages will be loaded once.
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************
 *Draws Lines once
 ****************/
void drawMovingTilesLines() {
  pg_Lines = createGraphics(int(worldSize.x), int(worldSize.y), P2D);    //creates canvas on which all will be drawn on
  pg_Lines.beginDraw();

  for (int j = 0; j< movingtiles.length; j++) {
    if (movingtiles[j] == null)
      break;
    if (blocks.size()<=0)
      break;
    int i=0;
    pg_Lines.stroke(255);
    while (movingtiles[j].Path[i+1][0] > 0) {
      math.DashedLine(movingtiles[j].Path[i][0]-round(15/ScaleScreenX), movingtiles[j].Path[i][1]-round(15/ScaleScreenY), movingtiles[j].Path[i+1][0]-round(15/ScaleScreenX), movingtiles[j].Path[i+1][1]-round(15/ScaleScreenY));
      i++;
    }
  }
  pg_Lines.endDraw();
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************
 *Draws Menu
 'Draws Menu Snake
 *****************/
boolean drawMenu() {
  if (shopmenu == true)                  //draws sizzling snake to buy
    showSnake();                         //Draws Snake in Buyscreen

  if (GameStart == false) {
    checkFeedback();                    //Checks which Button is pressed
    return true;
  }
  return false;
}

void resetSnakeCanvas() {
  shaderBlocks();
  SnakeGraphic.beginDraw();
  if (shaderOn == true)
    SnakeGraphic.shader(myShader);
  //SnakeGraphic.shader(FoodShader);
  SnakeGraphic.noStroke();
  SnakeGraphic.fill(BackgroundColor);
  SnakeGraphic.rect(0, 0, worldSize.x, worldSize.y);
  //SnakeGraphic.resetShader();
  if (shaderOn == true)
    SnakeGraphic.resetShader();
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*************************
 *Translate screen for every player playing
 *************************/
void translateCanvasPlayer(int count, int h) {
  for (int Player=0; Player<NumberPlayer; Player++) {
    translateMultiplayer(Player, count, h);      //translates the snake to the middle of players screen
    // updateRays(Player);                          //Draws Rays from each Player
    snake[Player].upgrades.update();             //Upgrades position of eaten upgrade in Snake
    if (NumberPlayer != 1) {                     //reverts the transformation back to state 0
      popMatrix();
      popMatrix();
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/******************************
 *Updates all game related stuff
 *Draws all gamerelated Stuff
 ******************************/
void updateGame() {
  updateSpecialAction();                //Updates missiles, path and minis
  if (snake[0].dead == true)            //Resets game if player dies
    lvls.reset();
  int count = 0;
  int h = -dHeight/4;
  if (NumberPlayer==2)
    h = 0;
  resetSnakeCanvas();
  translateCanvasPlayer(count, h);

  /****************
   *Draws the Screen
   ****************/
  DrawBackground();     //init background with grey, fade to black
  DrawSpecial();        //Draws all specials
  DrawSnake();          //Draws all Snakes
  DrawFood();           //Draws all food
  DrawMissile();        //Draws all missiles
  DrawPath();           //Draws all missile Paths -> should be integrated in DrawMissile!
  DrawBlocks();         //Draws all Blocks
  DrawFlash();
  DrawPortal();         //Draws all Portals
  UpdateMovingTiles();  //Draws all moving Blocks
  //DrawGlow();            //Draws Glow of all Snakes

  SnakeGraphic.endDraw();
  fill(255);
  DrawCanvas(count, h);  //Draws the screen
  SnakeGraphic.clear();  //Deletes saved canvas
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/
void draw() {
  if (drawMenu() == true)
    return;
  //Checks if the level is finished
  if (gamePause == true) {
    guiPages[4].DrawButtons();
    if (guiPages[4].Buttons.get(1).isFired()) {    //want to keep playing
      gamePause = false;
      lvl.winsize = 99999999;
      guiPages[4].active = false;
    } else if (guiPages[4].Buttons.get(2).isFired()) {    //wanna stop with this lvl
      guiPages[4].active = false;
      guiPages[0].active = true;
      gamePause = false;
      lvls.resetToMainScreen();
    }
    return;
  }
  if (lvls.victory() == true) {
    gamePause = true;
    background(255, 125);
    guiPages[4].active = true;
  }


  updateGame();
  //  DrawMultiSep();        //Draws Seperation line for all player
  DrawCursor();          //Draws Cursor if android mode is true -> Search a way that it does not have to be asked every frame
  //println(frameRate);
  DrawText();                           //Writes Text (Food, kills etc.) on screen
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/******************************
 *Updates Snakes position
 *Updates missiles
 *Updates missile Paths
 *Updates mini Snakes positions
 *******************************/
void updateSpecialAction() {
  for (Snake s : snake) {
    s.move();
    if (s.missilealive == true) {
      s.missile.move();
    }
    if (s.missile != null && s.missile.alive !=0) {
      s.path[s.missile.alive-1] = new MissilePath(s.missile.pos[0], s.missile.pos[1]);
      for (int i=0; i<s.missile.alive-1; i++) {
        if (s.path[i].alive >= 0) {
          s.path[i].update();
        }
      }
    }
    for (int m = 0; m < 2; m++) {
      
      if (s.upgrades.miniSnake[m]==true)
        s.mini[m].move();
    }
  }
}

/*******************************************************
 *translates multiplayersnakes to right position on screen
 *******************************************************/
void translateMultiplayer(int Player, int count, int h) {
  if (NumberPlayer!= 1) {
    if (snake[Player].dead == true) {
      snake[Player] = new Snake(false, Player);
      fillGrids();
    }
    pushMatrix();
    translate(pow(-1, Player+1)*dWidth/4, h);
    activeSnake = byte(Player);
    count++;
    if (count>=3)
    h = dHeight/4;
  }
  pushMatrix();
  translate(-1*snake[Player].body.get(0).pos.x+dWidth/2, -1*snake[Player].body.get(0).pos.y+dHeight/2);    //centers map around Snake
  // translate(-mouseX+dWidth/2, -mouseY+dHeight/2);    //centers map around Snake
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*************************************************
 *Init Screen Scalings for multiplayer translations
 **************************************************/
void setupMulti() {
  if (NumberPlayer >= 2) {
    ScaleScreenX = 0.5;
    if (NumberPlayer >=3)
    ScaleScreenY = 0.5;
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/********************************
 *Updates moving tiles on screen
 *********************************/
void UpdateMovingTiles() {
  for (int j = 0; j< movingtiles.length; j++) {
    if (movingtiles[j] == null)
    break;
    if (blocks.size()<=0)
    break;

    int speed = 30; //30 frames per Line
    float dx0 = (-movingtiles[j].Path[movingtiles[j].rectcorner+1][0]+movingtiles[j].Path[movingtiles[j].rectcorner][0]);    //length between start and endpoint of line
    float dy0 = (-movingtiles[j].Path[movingtiles[j].rectcorner+1][1]+movingtiles[j].Path[movingtiles[j].rectcorner][1]);
    float dx = dx0/speed;    //block travels this length per frame
    float dy = dy0/speed;

    movingtiles[j].StepMovingBlock++;

    /*Changes Block to the new position*/
    blocks.get(blocks.size()-(maxMTiles-j)).pos.x = round(blocks.get(blocks.size()-(maxMTiles-j)).pos.x-dx);
    blocks.get(blocks.size()-(maxMTiles-j)).pos.y = round(blocks.get(blocks.size()-(maxMTiles-j)).pos.y-dy);

    /*endpoint of one line is reached*/
    if (movingtiles[j].StepMovingBlock>=speed) {
      movingtiles[j].StepMovingBlock = 0;
      movingtiles[j].rectcorner++;
      if (movingtiles[j].rectcorner>movingtiles[j].maxCorner-2)
      movingtiles[j].rectcorner = 0;
    }

    PVector bPos = new PVector(blocks.get(blocks.size()-(maxMTiles-j)).pos.x, blocks.get(blocks.size()-(maxMTiles-j)).pos.y);
    if(blocks.get(blocks.size()-(maxMTiles-j)).fade == 255)
      continue;
      
    for (int s = 0; s < NumberPlayer; s++) {
      for (int b = 0; b < snake[s].body.size(); b++) {
        PVector sPos = snake[s].body.get(b).pos;
        float d = dist(sPos.x, sPos.y, bPos.x, bPos.y);
        if (d < snake[s].upgrades.glowdistance) {
          blocks.get(blocks.size()-(maxMTiles-j)).fade = 255;
          continue;
        }
      }
    }
  }

  fillGridsBlocks();      //To change that only the moving Tiles are updated and not all tiles!
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void shaderBlocks() {
  if (shaderOn == true) {
    int[] pointX = new int[lvl.count];
    int[] pointY = new int[lvl.count];
    int[] Glow = new int[4];
    for (int i=0; i<lvl.count-1; i++) {
      pointX[i] = round(blocks.get(i).pos.x+15);
      pointY[i] = round(blocks.get(i).pos.y+15);
      Glow[i] = blocks.get(i).fade;
    }

    myShader.set("pointX", pointX);
    myShader.set("pointY", pointY);
    myShader.set("size", blocks.get(0).size);
    myShader.set("Glow", Glow);
  }
}

void initSounds(){
  //init guiSounds
  String path = "sound/GUI/";
  guiSound[0] = new SoundFile(this, path+"Minimalist5.wav");
  guiSound[1] = new SoundFile(this, path+"Retro Event Acute 11.wav");
  
  //init gameSounds
  path = "sound/gameSound/";
  gameSound[0] = new SoundFile(this, path + "pickup.wav");
}