//TODO: Modus wo alle x secunden y schlangenteile sterben, der letzte gewinnt
//TODO: alle x futter, wird ein giftiges ausgekackt, was einen teile nimmt, zersetzt sich nach einiger Zeit

import processing.javafx.*;
float countFPS = 0;
int countf = 1;
void setup() {
  fullScreen(FX2D);
  background(125);
  
  WorldSizeX = width;
  WorldSizeY = height;
  MaxGrids = (WorldSizeX*(WorldSizeY)/(GridSize*GridSize));
  PFont myFont = createFont("Laksaman Bold", 30, true);
  textFont(myFont);
  
  initButtons();      //Adds starting Buttons
  datahandler.readJson();
 // SetupSnake();
}

/*************************************
 *Initialises program
 *************************************/
void SetupSnake() {
  for (int i=0; i<NumberPlayer; i++) {    //Adds Snakes played from player
    snake[i] = new Snake(false, int(random(800)), int(random(800)), i);
  }
  
  setupMulti();
  //for(int i=0;i<10;i++){
  //  movingtiles.movingBlocks[i][0] = -20;
  //  movingtiles.movingBlocks[i][1] = -20;
  //}
  lvls.start();                            //starts the first level

  for(int g = 0; g<MaxGrids;g++){    //init grids
    grid.add(new GridSystem(g));
  }
  fillGrids();
  SnakeGraphic = createGraphics(width,height);
  frameRate(GameSpeed);                    //sets the gamespeed to 30 fps

}
/**********************************
 *Draws the Canvas
 *opens every GameSpeed interval
 ***********************************/

void draw() {
  if(shopmenu == true)                  //draws sizzling snake to buy
    showSnake();
  if(GameStart == false)
    return;
  background(125);          //ro see outside the border
  text(frameRate,5,120);
  DrawText();
  lvls.victory();         //Checks if the level is finished
  updateSpecialAction();  //Updates missiles, path and minis
  if(snake[0].dead == true)
    lvls.reset();
  int count = 0;
  int h = -height/4;
  if (NumberPlayer==2)
    h = 0;
  SnakeGraphic.beginDraw();
  SnakeGraphic.background(125);
  
  
  for (int Player=0; Player<NumberPlayer; Player++) {
    translateMultiplayer(Player,count,h);
    updateRays(Player);
    snake[Player].upgrades.update();
   // DrawBorder(Player);
    if (NumberPlayer != 1){
      popMatrix();
      popMatrix();
    }
  }
  
  /****************
  *Draws the Screen
  ****************/
  DrawSpecial();
  DrawSnake();
  DrawFood();
  DrawMissile();
  DrawPath();
  DrawBlocks();
  DrawPortal();
  DrawMovingTiles();
   //<>//
  SnakeGraphic.endDraw();
  fill(255); 
  //  DrawGlow();
    
  DrawCanvas(count,h);
  SnakeGraphic.clear();
  DrawMultiSep();
  DrawCursor();
}

void drawBody(int Player, int bodyPart, int sizeBody){
  SnakeGraphic.fill(snake[Player].BodyColour(bodyPart), 255);
  SnakeGraphic.stroke(#000000);
  SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos[0], snake[Player].body.get(bodyPart).pos[1], sizeBody, sizeBody);
  SnakeGraphic.fill(snake[Player].BodyColour(bodyPart), 40);
  SnakeGraphic.noStroke();
  SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos[0], snake[Player].body.get(bodyPart).pos[1], sizeBody+10+sqrt(snake[Player].upgrades.glow),sizeBody+10+sqrt(snake[Player].upgrades.glow));
  SnakeGraphic.stroke(1); 
  snake[Player].body.get(bodyPart).size = snake[Player].size;    
}
void drawBodyMini(miniSnake mini,int j){
  SnakeGraphic.fill(mini.BodyColour(j), 255);
  SnakeGraphic.stroke(#000000);
  SnakeGraphic.ellipse(mini.body.get(j).pos[0], mini.body.get(j).pos[1], mini.size,mini.size);
  SnakeGraphic.fill(mini.BodyColour(j), 40);
  SnakeGraphic.noStroke();
  SnakeGraphic.ellipse(mini.body.get(j).pos[0], mini.body.get(j).pos[1], mini.size+5,mini.size+5);
  SnakeGraphic.stroke(1); 
}
/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  for (int Player=0; Player<snake.length; Player++) {
    if (snake[0].dead==true){
      lvls.reset();
      return;
    }
    int sizeBody = snake[Player].size;
    for (int bodyPart=0; bodyPart<snake[Player].SLength; bodyPart++) {
      sizeBody = snake[Player].body.get(bodyPart).size;
      drawBody(Player,bodyPart,sizeBody);
    }
    if (snake[Player].upgrades.miniSnake == true) {
        for (miniSnake mini : snake[Player].mini) {
          //mini.move();
          for (int j=0; j<mini.SLength; j++) {
            //if (math.checkBoundaries(mini.body.get(j).pos[0], mini.body.get(j).pos[1], mini.size)) {
              drawBodyMini(mini,j);
           // }
          }
        }
      }
  }
}

void DrawCursor() {
  if (isAndroid == false)
    return;
  PImage img = loadImage("/data/img/special_rocket.png");
  img.resize(100, 100);
  image(img, width-200, height-200);
  img = loadImage("/data/img/speed.png");
  image(img, width-100, height-100);
  if (mousePressed == false)
    return;

  noFill();
  stroke(255);
  int circleSize = 300;
  int x = 0;
  int y = 0;
  circle(mousepos[0], mousepos[1], circleSize);    //circle for mousemove
  if (dist(mousepos[0], mousepos[1], mouseX, mouseY)>circleSize/2) {    //too far away
    x = int((-mousepos[0]+mouseX)*0.5*circleSize/dist(mousepos[0], mousepos[1], mouseX, mouseY))+mousepos[0];
    y = int((-mousepos[1]+mouseY)*0.5*circleSize/dist(mousepos[0], mousepos[1], mouseX, mouseY))+mousepos[1];
    fill(255);
    circle(x, y, 50);
  } else {
    x = mouseX;
    y = mouseY;
    fill(255);
    circle(x, y, 50);
  }
  AndroidAngle = math.Anglecalc(mousepos[0], mousepos[1], x, y);
}


void DrawGlow() {
  if (snake[0].upgrades.glow == 0)
    return;
  PShape glowShape = createShape();
  PShape glowShapeInner = createShape();
  glowShape.beginShape();
  glowShape.fill(255, 20);
  glowShape.noStroke();
  glowShapeInner.beginShape();
  glowShapeInner.fill(255, 20);
  glowShapeInner.noStroke();

  for (int i= 0; i<10; i++) {
    int x1 = snake[0].body.get(0).pos[0];
    int y1 = snake[0].body.get(0).pos[1];
    int x2 = int(x1+snake[0].upgrades.glow*math.sinAlike(snake[0].Angle-i*PI/10));
    int y2 = int(y1-snake[0].upgrades.glow*math.cosAlike(snake[0].Angle-i*PI/10));
    if (math.checkBoundaries(x2, y2, 1)) {
      glowShape.vertex(x1+snake[0].upgrades.glow*math.sinS(snake[0].Angle-i*PI/10), y1-snake[0].upgrades.glow*math.cosS(snake[0].Angle-i*PI/10));
      glowShapeInner.vertex(x1+0.5*snake[0].upgrades.glow*math.sinS(snake[0].Angle-i*PI/10), y1-0.5*snake[0].upgrades.glow*math.cosS(snake[0].Angle-i*PI/10));
    } else {
    }
  }
  for (int i=0; i<snake[0].body.size()-1; i++) {
    int x1 = snake[0].body.get(i).pos[0];
    int y1 = snake[0].body.get(i).pos[1];
    int x2 = snake[0].body.get(i+1).pos[0];
    int y2 = snake[0].body.get(i+1).pos[1];
    float Angle = math.Anglecalc(x1, y1, x2, y2);

    glowShape.vertex(x1+snake[0].upgrades.glow*math.sinS(Angle), y1-snake[0].upgrades.glow*cos(Angle));
    glowShapeInner.vertex(x1+0.5*snake[0].upgrades.glow*math.sinS(Angle), y1-0.5*snake[0].upgrades.glow*math.cosS(Angle));
  }
  for (int i= 10; i>=0; i--) {
    int x1 = snake[0].body.get(snake[0].body.size()-1).pos[0];
    int y1 = snake[0].body.get(snake[0].body.size()-1).pos[1];
    int x2 = snake[0].body.get(snake[0].body.size()-2).pos[0];
    int y2 = snake[0].body.get(snake[0].body.size()-2).pos[1];
    float Angle = math.Anglecalc(x1, y1, x2, y2);
    glowShape.vertex(x1+snake[0].upgrades.glow*math.sinS(Angle+i*PI/10), y1-snake[0].upgrades.glow*math.cosS(Angle+i*PI/10));
    glowShapeInner.vertex(x1+0.5*snake[0].upgrades.glow*math.sinS(Angle+i*PI/10), y1-0.5*snake[0].upgrades.glow*math.cosS(Angle+i*PI/10));
  }
  for (int i=snake[0].body.size()-1; i>1; i--) {
    int x1 = snake[0].body.get(i).pos[0];
    int y1 = snake[0].body.get(i).pos[1];
    int x2 = snake[0].body.get(i-1).pos[0];
    int y2 = snake[0].body.get(i-1).pos[1];
    float Angle = math.Anglecalc(x1, y1, x2, y2);

    glowShape.vertex(x1+snake[0].upgrades.glow*math.sinS(Angle), y1-snake[0].upgrades.glow*math.cosS(Angle));
    glowShapeInner.vertex(x1+0.5*snake[0].upgrades.glow*math.sinS(Angle), y1-0.5*snake[0].upgrades.glow*math.cosS(Angle));
  }

  glowShape.endShape(CLOSE);
  glowShapeInner.endShape(CLOSE);

  shape(glowShape);
  shape(glowShapeInner);
}

/**********************************
 *Draws the Portal(s)
 **********************************/
void DrawPortal() {
  if (lvl.setPortal) {
    for (byte i=0; i<MaxPortals; i++) {      //repeat for every portal in existance

        SnakeGraphic.strokeWeight(3);
        SnakeGraphic.stroke(portal[i].colour1, 30);
        SnakeGraphic.ellipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size*0.5+2, portal[i].size+4);
        SnakeGraphic.stroke(portal[i].colour1);
        SnakeGraphic.fill(#D8FFF8);
        SnakeGraphic.ellipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size*0.5, portal[i].size);

        SnakeGraphic.stroke(portal[i].colour2, 30);
        SnakeGraphic.ellipse(portal[i].pos[1][0], portal[i].pos[1][1], portal[i].size*0.5+2, portal[i].size+4);
        SnakeGraphic.stroke(portal[i].colour2);
        SnakeGraphic.fill(#FFE815);
        SnakeGraphic.ellipse(portal[i].pos[1][0], portal[i].pos[1][1], portal[i].size*0.5, portal[i].size);


        //GridSystem einpflegen, nur abfragen, wenn snake nah genug an einem der beiden Portale ist!
        boolean near = false;
        float distance = 9999;
        for(Snake s: snake){
          if(dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1]) < 100){
            near = true;
            if (dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1])<distance)
              distance = dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1]);
          }
          else if(dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1]) < 100)
            near = true;
            if (dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1])<distance)
              distance = dist(s.body.get(0).pos[0],s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1]);
        }
        if(near == true){
          SnakeGraphic.stroke(#00FFFF,2550/((distance+1)));
          SnakeGraphic.line(portal[i].pos[0][0], portal[i].pos[0][1],portal[i].pos[1][0], portal[i].pos[1][1]);
        }
        
    }
    SnakeGraphic.strokeWeight(1);
  }
}

/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {
  for (int i=0; i<food.size(); i++) {
   // if (math.checkBoundaries(food.get(i).posx, food.get(i).posy, food.get(i).size)) {
      
      if (food.get(i).size == 30) {                //if food has no rays on it
        drawGradient(food.get(i).posx, food.get(i).posy, food.get(i).size);    //draw a circle with blurry circumfence
      } else {                                     //food is seen by the rays
        SnakeGraphic.fill(food.get(i).BGcolour);
        SnakeGraphic.stroke(food.get(i).colour);
        SnakeGraphic.ellipse(food.get(i).posx, food.get(i).posy, food.get(i).size, food.get(i).size);
        food.get(i).colour = 0;                    //resets food to not seen every time
        food.get(i).BGcolour = #00160D;
        food.get(i).size = 30;
      }
    //  food.get(i).outofBounds = false; 
    }
   // else{
   //  food.get(i).outofBounds = true; 
   // }
  //}
}

/**********************************
 *Draws the gradient of food
 ***********************************/
void drawGradient(float x, float y, int size) {
  SnakeGraphic.noStroke();
  for(int r = size/3; r<=size;r+=size/3){
   SnakeGraphic.fill(0,0,255,10*(1-(r/size)));
   SnakeGraphic.ellipse(x,y,r,r);
  }
}

/**************************************
 *Draws the Missile
 **************************************/
void DrawMissile() {
  for (Snake s : snake) {
    if (s.missilealive == true) {
      //s.missile.move();
      SnakeGraphic.fill(#FF0000);
      SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 3,3);
      SnakeGraphic.fill(#FFAAAA, 50);
      SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 9,9);
    }
  }
}

/**************************************
 *Draws the Path of the Missile
 **************************************/
void DrawPath() {
  for (Snake s : snake ) {
    if (s == null || s.missile == null || s.missile.alive ==0)
      return;
    s.path[s.missile.alive-1] = new MissilePath(s.missile.pos[0], s.missile.pos[1]);
    for (int i=0; i<s.missile.alive-1; i++) {
      if (s.path[i].alive >= 0) {
        SnakeGraphic.fill(#FFFFFF, s.path[i].fade);
        SnakeGraphic.ellipse(s.path[i].pos[0], s.path[i].pos[1], s.path[i].size,s.path[i].size);
        //path[i].update();
      }
    }
  }
}

/**************************
 *Draws all blocks on screen
 **************************/
void DrawBlocks() {
  for (int i=0; i<lvl.blocksize/2-1; i++) {
   // if (math.checkBoundaries(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size)) {
      
        //int i = grid.get(grids.get(b)).block.get(c);
        if (blocks.get(i).RayCast == true) {
          SnakeGraphic.noStroke();
          SnakeGraphic.fill(blocks.get(i).colour, 50);
          SnakeGraphic.rect(blocks.get(i).pos[0]-3, blocks.get(i).pos[1]-3, blocks.get(i).size+6, blocks.get(i).size+6);
  
          SnakeGraphic.stroke(1);
          SnakeGraphic.fill(blocks.get(i).colour);
          SnakeGraphic.rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
          blocks.get(i).RayCast = false;
        }
        SnakeGraphic.fill(blocks.get(i).colour, blocks.get(i).fade);
        SnakeGraphic.stroke(1);
        SnakeGraphic.rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
        blocks.get(i).fade= max(blocks.get(i).fade-10, 0);
        blocks.get(i).outofBounds = false;
     // }
    
   // else{
    //  blocks.get(i).outofBounds = true;
    //}
  }
}

void DrawSpecial() {
  //snake[count].upgrades.update();
  if (specials.size()==0)
    return;
  for (Special special : specials) {
   // if (math.checkBoundaries(special.pos[0], special.pos[1], special.size)) {
      PImage img = loadImage("/data/img/special_rocket.png");
      if (special.Specialvalue == 0)
        img = loadImage("/data/img/special_rocket.png");
      else if (special.Specialvalue == 1)
        img = loadImage("/data/img/speed.png");
      else if (special.Specialvalue == 2)
        img = loadImage("/data/img/miniSnake.png");
      else if (special.Specialvalue == 3)
        img = loadImage("/data/img/special_dist.png");
      else if (special.Specialvalue == 4)
        img = loadImage("/data/img/special_widening.png");
      else if (special.Specialvalue == 5)
        img = loadImage("/data/img/glow.png");
      SnakeGraphic.fill(0);
      SnakeGraphic.ellipse(special.pos[0], special.pos[1], special.size,special.size);
      img.resize(special.size, special.size);
      SnakeGraphic.image(img, special.pos[0]-special.size/2, special.pos[1]-special.size/2);
   // }
  }
}


/**************************
 *Draws all Text on screen
 **************************/
void DrawText() {
  String text = "Food: "+ maxFood+
    "\nSnake Size: "+snake[0].SLength;
  text(text, 0, 30);
}

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

 void translateMultiplayer(int Player, int count, int h){
    if (NumberPlayer!= 1) {
      if (snake[Player].dead == true) {
        //for (SnakeBody b : snake[Player].body) {
        //  if (random(100)<30)
        //    food.add(new Food(0, round(random(0.6)), b.pos[0], b.pos[1]));
        //  else if (random(100)<3)
        //    food.add(new Food(0, 2, b.pos[0], b.pos[1]));
        //}
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
    //translate(-1*snake[Player].body.get(0).pos[0]+width/2, -1*snake[Player].body.get(0).pos[1]+height/2);    //centers map around Snake
    translate(-mouseX+width/2, -mouseY+height/2);    //centers map around Snake
  }
  
  void DrawMultiSep(){
    stroke(0);
    if(NumberPlayer == 1)
      return;
      line(width/2, 0, width/2, height);
    if(NumberPlayer >=3)
      line(0,height/2,width,height/2);
  }
  
  void DrawBorder(int Player){
    stroke(5);
    if(snake[Player].body.get(0).pos[0] -width/4 <0 )
      line(0,0,0,height);    
    if(snake[Player].body.get(0).pos[1] -height/2 <0 )      //obere Linie
      if(snake[Player].body.get(0).pos[0] -width/4 <0)
        line(0,0,snake[Player].body.get(0).pos[0] +width/4,0);    
      else if(snake[Player].body.get(0).pos[0] +width/4 >width)
        line(snake[Player].body.get(0).pos[0] -width/4,0,width,0);
      else
        line(snake[Player].body.get(0).pos[0] -width/4,0,snake[Player].body.get(0).pos[0] +width/4,0);
    if(snake[Player].body.get(0).pos[0] +width/4 >width )
      line(width,0,width,height);
    if(snake[Player].body.get(0).pos[1] +height/2 >height )      //Untere Linie
      if(snake[Player].body.get(0).pos[0] -width/4 <0)
        line(0,height,snake[Player].body.get(0).pos[0] +width/4,height);    
      else if(snake[Player].body.get(0).pos[0] +width/4 >width)
        line(snake[Player].body.get(0).pos[0] -width/4,height,width,height);
      else
        line(snake[Player].body.get(0).pos[0] -width/4,height,snake[Player].body.get(0).pos[0] +width/4,height);
    stroke(1);
  }
  
  void DrawCanvas(int count, int h){
    count = 0;
    int h2 = height/2;
    for (int Player=0; Player<NumberPlayer; Player++) {
      if(NumberPlayer >1)
        translateMultiplayer(Player,count,h);                //left snake left side, right snake right side
      
      //image(SnakeGraphic.get(
      //    snake[Player].body.get(0).pos[0]-width/4,
      //    snake[Player].body.get(0).pos[1]-height/2,
      //    width/2,height),
      //  snake[Player].body.get(0).pos[0]-width/4,
      //  snake[Player].body.get(0).pos[1]-h2);
      
      image(SnakeGraphic,
        mouseX-width/2,
        mouseY-h2);
      
      popMatrix();
      if (NumberPlayer != 1)
        popMatrix();
      count ++;
      if(count >=2)
        h2=0;
    }
  }
  void setupMulti(){
    /*****************
    *Init Multiplayer
    *****************/
    if(NumberPlayer >= 2){
      ScaleScreenX = 0.5;
      if(NumberPlayer >=3)
        ScaleScreenY = 0.5;
    }
  }
  
  void updateRays(int Player){
   if (snake[Player].ray[0] != null) {
      int z = int(snake[Player].Angle*180/PI-2*snake[Player].upgrades.RayRadius*180/PI);
      if(z<0)
        z = maxRays-abs(z);
      for(int k=1;k<4;k++){
        snake[Player].gridIDsRay = FindGrid(snake[Player].upgrades.RayDistance/k,Player);
        SnakeGraphic.beginShape();
        SnakeGraphic.fill(255,70);
        SnakeGraphic.noStroke();
        SnakeGraphic.vertex(snake[Player].body.get(0).pos[0],snake[Player].body.get(0).pos[1]);
        for (int i=0; i<maxRays; i++) {
          snake[Player].ray[(i+z)%maxRays].update(snake[Player].body.get(0).pos[0], snake[Player].body.get(0).pos[1], snake[Player].Angle,k);
        }
        SnakeGraphic.endShape(CLOSE);
      }
    } 
  }
  
  void DrawMovingTiles(){
    int i=0;
    
    Boolean near = false;
      //<>//
    
    while(movingtiles.Path[i+1][0] > 0){
      SnakeGraphic.stroke(255);
      math.DashedLine(movingtiles.Path[i][0],movingtiles.Path[i][1],movingtiles.Path[i+1][0],movingtiles.Path[i+1][1]);
      i++;
    } 
    int speed = 100;
    float dx = (-movingtiles.Path[movingtiles.rectcorner+1][0]+movingtiles.Path[movingtiles.rectcorner][0])/30;
    float dy = (-movingtiles.Path[movingtiles.rectcorner+1][1]+movingtiles.Path[movingtiles.rectcorner][1])/30;

    if(movingtiles.StepMovingBlock==30){
      movingtiles.StepMovingBlock = 0;
      movingtiles.rectcorner++;
      if(movingtiles.rectcorner>3)
        movingtiles.rectcorner = 0;
      
    }
    movingtiles.StepMovingBlock++;
    //if (abs(blocks.get(blocks.size()-1).pos[0]-movingBlocks[rectcorner+1][0]) < maxx && abs(blocks.get(blocks.size()-1).pos[1]-movingBlocks[rectcorner+1][1]) < maxy)
    blocks.get(blocks.size()-1).pos[0] = int(blocks.get(blocks.size()-1).pos[0]-dx);
    blocks.get(blocks.size()-1).pos[1] = int(blocks.get(blocks.size()-1).pos[1]-dy);
    fillGridsBlocks();
     //<>//
  }
