//TODO: Modus wo alle x secunden y schlangenteile sterben, der letzte gewinnt //<>// //<>// //<>//
//TODO: alle x futter, wird ein giftiges ausgekackt, was einen teile nimmt, zersetzt sich nach einiger Zeit

//import processing.javafx.*;



/***********************************
*TODO:
*statt boundary die Map wiederholen?
*erstmal ohne shader programmieren
*Maplvl machen
*refactoring
*grafik erstellen, was mit was zusammenhängt und wie oft?
*shopmenü erstellen
*auf android lauffähig machen
*videos aufnehmen beim Programmieren
*extra PGraphics für Food & specials, für Blöcke (nur einmal zeichnen sollte nötig sein, für schlange, für Linien auf Map)
**********************************/

void setup() {
  fullScreen(P2D);
  background(BackgroundColor);     //color of interface background
  MaxGrids = (WorldSizeX*(WorldSizeY)/(GridSize*GridSize));    //Sets the maximum grid size
  PFont myFont = createFont("Laksaman Bold", sizeFont, true);  //Sets font to be used in the game
  textFont(myFont);

  initButtons();      //Adds starting Buttons
  datahandler.readJson();      //reads variables from json like food eaten and snakes bought
}

/*************************************
 *Initialises program
 *************************************/
void SetupSnake() {
  for (int i=0; i<NumberPlayer; i++) {    //Adds Snakes played from player
    snake[i] = new Snake(false, int(random(800)), int(random(800)), i);
  }

  setupMulti();                            //Sets up Multiplayer screen
  lvls.start();                            //starts the first level

  for (int g = 0; g<MaxGrids; g++) {      //init grids
    grid.add(new GridSystem(g));
  }
  
  fillGrids();                            //fills grids with blocks, food and snakebodyparts
  SnakeGraphic = createGraphics(WorldSizeX, WorldSizeY,P2D);    //creates canvas on which all will be drawn on
  
  /****************
  *Draws Lines once
  ****************/
  pg_Lines = createGraphics(WorldSizeX, WorldSizeY,P2D);    //creates canvas on which all will be drawn on
  pg_Lines.beginDraw();
  for (int j = 0; j< movingtiles.length; j++) {
    if (movingtiles[j] == null)
      break;
    if (blocks.size()<=0)
      break;
    int i=0;
    pg_Lines.stroke(255);
    while (movingtiles[j].Path[i+1][0] > 0) {
      math.DashedLine(movingtiles[j].Path[i][0], movingtiles[j].Path[i][1], movingtiles[j].Path[i+1][0], movingtiles[j].Path[i+1][1]);
      i++;
    }
  }
  pg_Lines.endDraw();
  /***************************/
  
  frameRate(GameSpeed);                    //sets the gamespeed to 30 fps
  
  if(shaderOn == true){
    myShader = loadShader("data/shader/Block_shader.frag");
    myShader.set("resolution", float(width), float(height));
    
    FoodShader = loadShader("data/shader/Food_Shader.frag");
    FoodShader.set("resolution", float(width), float(height));
  } else{
    String[] FoodNames = {"RedDimm.png","RedBright.png","GreenDimm.png","GreenBright.png","BlueDimm.png","BlueBright.png","GoldDimm.png","GoldBright.png"};
    for(int i = 0; i < 8 ; i ++)
      i_Food[i] = loadImage("img/"+FoodNames[i]);        //foodimages will be loaded once.
  }
}
/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/

void draw() {
   if (shopmenu == true)                  //draws sizzling snake to buy
    showSnake();                         //Draws Snake in Buyscreen

  if (GameStart == false) {
    checkFeedback();                    //Checks which Button is pressed
    return;
  }
  background(BackgroundColor);
  text(frameRate, 5, 120);              //Shows Framerate outside the gamescreen
  
  
  lvls.victory();                       //Checks if the level is finished
  updateSpecialAction();                //Updates missiles, path and minis
  
  if (snake[0].dead == true)            //Resets game if player dies
    lvls.reset();
    
  int count = 0;
  int h = -height/4;
  if (NumberPlayer==2)
    h = 0;
    
  //Shader     ******************************************************************
  if(shaderOn == true){
    int[] pointX = new int[lvl.count];
    int[] pointY = new int[lvl.count];
    int[] Glow = new int[4];
    for(int i=0; i<lvl.count-1; i++){
      pointX[i] = blocks.get(i).pos[0]+15;
      pointY[i] = blocks.get(i).pos[1]+15;
      Glow[i] = blocks.get(i).fade;
    }
  
    myShader.set("pointX", pointX);
    myShader.set("pointY", pointY);
    myShader.set("size", blocks.get(0).size); 
    myShader.set("Glow", Glow);
  }

  
  SnakeGraphic.beginDraw();
  if(shaderOn == true)
    SnakeGraphic.shader(myShader);
  //SnakeGraphic.shader(FoodShader);
  SnakeGraphic.noStroke();
  SnakeGraphic.fill(BackgroundColor);
  SnakeGraphic.rect(0,0,width,height);
  //SnakeGraphic.resetShader();
  if(shaderOn == true)
    SnakeGraphic.resetShader();
    
  /*************************
  *Translate screen for every player playing
  *************************/
  for (int Player=0; Player<NumberPlayer; Player++) {
    translateMultiplayer(Player, count, h);      //translates the snake to the middle of players screen
    updateRays(Player);                          //Draws Rays from each Player
    snake[Player].upgrades.update();             //Upgrades position of eaten upgrade in Snake
    if (NumberPlayer != 1) {                     //reverts the transformation back to state 0
      popMatrix();
      popMatrix();
    }
  }

  /****************
   *Draws the Screen
   ****************/
  DrawSpecial();        //Draws all specials
  DrawSnake();          //Draws all Snakes
  DrawFood();           //Draws all food
  DrawMissile();        //Draws all missiles
  DrawPath();           //Draws all missile Paths -> should be integrated in DrawMissile!
  DrawBlocks();         //Draws all Blocks
  DrawPortal();         //Draws all Portals
  UpdateMovingTiles();  //Draws all moving Blocks
  //DrawGlow();            //Draws Glow of all Snakes
  
  SnakeGraphic.endDraw();
  fill(255);
  DrawCanvas(count, h);  //Draws the screen
  SnakeGraphic.clear();  //Deletes saved canvas
//  DrawMultiSep();        //Draws Seperation line for all player
  DrawCursor();          //Draws Cursor if android mode is true -> Search a way that it does not have to be asked every frame
 //println(frameRate);
 DrawText();                           //Writes Text (Food, kills etc.) on screen
}


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
    for (miniSnake mini : s.mini) {
      if (s.upgrades.miniSnake==true)
        mini.move();
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
    translate(pow(-1, Player+1)*width/4, h);
    activeSnake = byte(Player);
    count++;
    if (count>=3)
      h = height/4;
  }
  pushMatrix();
  translate(-1*snake[Player].body.get(0).pos[0]+width/2, -1*snake[Player].body.get(0).pos[1]+height/2);    //centers map around Snake
  //  translate(-mouseX+width/2, -mouseY+height/2);    //centers map around Snake
}

/*************************************************
*Init Screen Scalings for multiplayer translations
**************************************************/
void setupMulti() {
  /*****************
   *Init Multiplayer
   *****************/
  if (NumberPlayer >= 2) {
    ScaleScreenX = 0.5;
    if (NumberPlayer >=3)
      ScaleScreenY = 0.5;
  }
}

/**************************************
*Updates Rays of the snakes to see
**************************************/
void updateRays(int Player) {
  if (snake[Player].ray[0] != null) {
    int z = int(snake[Player].Angle*180/PI-2*snake[Player].upgrades.RayRadius*180/PI);
    if (z<0)
      z = maxRays-abs(z);
    for (int k=1; k<4; k++) {              //Draws Snake Rays as a triangle
      snake[Player].gridIDsRay = FindGrid(snake[Player].upgrades.RayDistance/k, Player);
      SnakeGraphic.beginShape();
      SnakeGraphic.fill(255, 70);
      SnakeGraphic.noStroke();
      SnakeGraphic.vertex(snake[Player].body.get(0).pos[0], snake[Player].body.get(0).pos[1]);
      for (int i=0; i<maxRays; i++) {
        snake[Player].ray[(i+z)%maxRays].update(snake[Player].body.get(0).pos[0], snake[Player].body.get(0).pos[1], snake[Player].Angle, k);
      }
      SnakeGraphic.endShape(CLOSE);
    }
  }
}

/********************************
*Updates moving tiles on screen
*********************************/
void UpdateMovingTiles() {
  for (int j = 0; j< movingtiles.length; j++) {
    if (movingtiles[j] == null)
      break;
    if (blocks.size()<=0)
      break;
    //int i=0;
    //while (movingtiles[j].Path[i+1][0] > 0) {
    //  SnakeGraphic.stroke(255);
    //  math.DashedLine(movingtiles[j].Path[i][0], movingtiles[j].Path[i][1], movingtiles[j].Path[i+1][0], movingtiles[j].Path[i+1][1]);
    //  i++;
    //}
    int k=0;
    int z=0;
    int speed = 30; //30 frames per Line
    float dx0 = (-movingtiles[j].Path[movingtiles[j].rectcorner+1][0]+movingtiles[j].Path[movingtiles[j].rectcorner][0]);    //length between start and endpoint of line
    float dy0 = (-movingtiles[j].Path[movingtiles[j].rectcorner+1][1]+movingtiles[j].Path[movingtiles[j].rectcorner][1]);
    float dx = dx0/speed;    //block travels this length per frame
    float dy = dy0/speed;

    movingtiles[j].StepMovingBlock++;

    /*Changes Block to the new position*/
    blocks.get(blocks.size()-(maxMTiles-j)).pos[0] = round(blocks.get(blocks.size()-(maxMTiles-j)).pos[0]-dx);
    blocks.get(blocks.size()-(maxMTiles-j)).pos[1] = round(blocks.get(blocks.size()-(maxMTiles-j)).pos[1]-dy);

    /*endpoint of one line is reached*/
    if (movingtiles[j].StepMovingBlock>=speed) {
      movingtiles[j].StepMovingBlock = 0;
      movingtiles[j].rectcorner++;
      if (movingtiles[j].rectcorner>movingtiles[j].maxCorner-2)
        movingtiles[j].rectcorner = 0;
    }
  }
  fillGridsBlocks();      //To change that only the moving Tiles are updated and not all tiles!
}
