/**************************************
*Draws the bodypart of each given snake
**************************************/
void drawBody(int Player, int bodyPart, int sizeBody) {
  SnakeGraphic.fill(snake[Player].BodyColour(bodyPart), 255);
  SnakeGraphic.stroke(#000000);
  SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos[0], snake[Player].body.get(bodyPart).pos[1], sizeBody, sizeBody);
  SnakeGraphic.fill(snake[Player].BodyColour(bodyPart), 40);
  SnakeGraphic.noStroke();
  SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos[0], snake[Player].body.get(bodyPart).pos[1], sizeBody+10+sqrt(snake[Player].upgrades.glow), sizeBody+10+sqrt(snake[Player].upgrades.glow));
  SnakeGraphic.stroke(1);
  snake[Player].body.get(bodyPart).size = snake[Player].size;
}

/*****************************
*Draws the body of mini snakes
*****************************/
void drawBodyMini(miniSnake mini, int j) {
  SnakeGraphic.fill(mini.BodyColour(j), 255);
  SnakeGraphic.stroke(#000000);
  SnakeGraphic.ellipse(mini.body.get(j).pos[0], mini.body.get(j).pos[1], mini.size, mini.size);
  SnakeGraphic.fill(mini.BodyColour(j), 40);
  SnakeGraphic.noStroke();
  SnakeGraphic.ellipse(mini.body.get(j).pos[0], mini.body.get(j).pos[1], mini.size+5, mini.size+5);
  SnakeGraphic.stroke(1);
}
/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  for (int Player=0; Player<snake.length; Player++) {
    if (snake[0].dead==true) {
      lvls.reset();
      return;
    }
    int sizeBody = snake[Player].size;
    if(shaderOn == true){
        
    } else{
      for (int bodyPart=0; bodyPart<snake[Player].SLength; bodyPart++) {
        sizeBody = snake[Player].body.get(bodyPart).size;
        drawBody(Player, bodyPart, sizeBody);
      }
    }
    if (snake[Player].upgrades.miniSnake == true) {
      if(shaderOn == true){
        
      } else{
        for (miniSnake mini : snake[Player].mini) {
          for (int j=0; j<mini.SLength; j++) {
            drawBodyMini(mini, j);
          }
        }
      }
    }
  }
}

/**********************************
*Draws Cursor for Handheld on screen
************************************/
void DrawCursor() {
  if (isAndroid == false)
    return;
  PImage img = loadImage("img/special_rocket.png");
  img.resize(100, 100);
  image(img, width-200, height-200);
  img = loadImage("img/speed.png");
  image(img, width-100, height-100);
  if (mousePressed == false)
    return;
  DrawCircleFinger();          //Draws Circle on screen
}

/********************************************
*Draws Circle on Screen when touched (Android)
*********************************************/
void DrawCircleFinger(){
  noFill();
  stroke(255);
  int circleSize = 300;
  int x = 0;
  int y = 0;
  circle(mousepos[0], mousepos[1], circleSize);    //circle for mousemove
  if (dist(mousepos[0], mousepos[1], mouseX, mouseY)>circleSize/2) {    //too far away, gets cut to the right distance
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

/**************************************
*Draws Glowradius from Snake on screen
***************************************/
void DrawGlow() {
  for(int Player=0; Player<NumberPlayer; Player++){
    if (snake[Player].upgrades.glow == 0)
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
      int x1 = snake[Player].body.get(0).pos[0];
      int y1 = snake[Player].body.get(0).pos[1];
      int x2 = int(x1+snake[Player].upgrades.glow*math.sinAlike(snake[0].Angle-i*PI/10));
      int y2 = int(y1-snake[Player].upgrades.glow*math.cosAlike(snake[0].Angle-i*PI/10));
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(snake[Player].Angle-i*PI/10), y1-snake[Player].upgrades.glow*math.cosS(snake[Player].Angle-i*PI/10));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(snake[Player].Angle-i*PI/10), y1-0.5*snake[Player].upgrades.glow*math.cosS(snake[Player].Angle-i*PI/10));
    }
    for (int i=0; i<snake[Player].body.size()-1; i++) {
      int x1 = snake[Player].body.get(i).pos[0];
      int y1 = snake[Player].body.get(i).pos[1];
      int x2 = snake[Player].body.get(i+1).pos[0];
      int y2 = snake[Player].body.get(i+1).pos[1];
      float Angle = math.Anglecalc(x1, y1, x2, y2);
  
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(Angle), y1-snake[Player].upgrades.glow*cos(Angle));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(Angle), y1-0.5*snake[Player].upgrades.glow*math.cosS(Angle));
    }
    for (int i= 10; i>=0; i--) {
      int x1 = snake[Player].body.get(snake[Player].body.size()-1).pos[0];
      int y1 = snake[Player].body.get(snake[Player].body.size()-1).pos[1];
      int x2 = snake[Player].body.get(snake[Player].body.size()-2).pos[0];
      int y2 = snake[Player].body.get(snake[Player].body.size()-2).pos[1];
      float Angle = math.Anglecalc(x1, y1, x2, y2);
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(Angle+i*PI/10), y1-snake[Player].upgrades.glow*math.cosS(Angle+i*PI/10));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(Angle+i*PI/10), y1-0.5*snake[Player].upgrades.glow*math.cosS(Angle+i*PI/10));
    }
    for (int i=snake[Player].body.size()-1; i>1; i--) {
      int x1 = snake[Player].body.get(i).pos[0];
      int y1 = snake[Player].body.get(i).pos[1];
      int x2 = snake[Player].body.get(i-1).pos[0];
      int y2 = snake[Player].body.get(i-1).pos[1];
      float Angle = math.Anglecalc(x1, y1, x2, y2);
  
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(Angle), y1-snake[Player].upgrades.glow*math.cosS(Angle));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(Angle), y1-0.5*snake[Player].upgrades.glow*math.cosS(Angle));
    }
  
    glowShape.endShape(CLOSE);
    glowShapeInner.endShape(CLOSE);
  
    SnakeGraphic.shape(glowShape);
    SnakeGraphic.shape(glowShapeInner);
  }
}

/**********************************
 *Draws the Portal(s)
 **********************************/
 
 void DrawEllipse(int x, int y, float size,  int weight, color colour, int opa, color fill){
    SnakeGraphic.strokeWeight(weight);
    SnakeGraphic.stroke(colour, opa);
    SnakeGraphic.ellipse(x, y, size*0.5+2, size+4);
    SnakeGraphic.stroke(colour);
    SnakeGraphic.fill(fill);
    SnakeGraphic.ellipse(x, y, size*0.5, size);
 }
 
void DrawPortal() {
  if (lvl.setPortal) {
    for (byte i=0; i<MaxPortals; i++) {      //repeat for every portal in existance
      DrawEllipse(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].size, 3, portal[i].colour1, 30, #D8FFF8);      //Draws Portal
      DrawEllipse(portal[i].pos[1][0], portal[i].pos[1][1], portal[i].size, 3, portal[i].colour2, 30, #FFE815);

      //GridSystem einpflegen, nur abfragen, wenn snake nah genug an einem der beiden Portale ist!
      boolean near = false;
      float distance = 9999;
      
      /*Line appers which connects the 2 portals, if one snake is close enough*/
      for (Snake s : snake) {
        if (dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1]) < 100) {
          near = true;
          if (dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1])<distance)
            distance = dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[1][0], portal[i].pos[1][1]);
        } else if (dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1]) < 100)
          near = true;
        if (dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1])<distance)
          distance = dist(s.body.get(0).pos[0], s.body.get(0).pos[1], portal[i].pos[0][0], portal[i].pos[0][1]);
      }
      if (near == true) {
        SnakeGraphic.stroke(#00FFFF, 2550/((distance+1)));
        SnakeGraphic.line(portal[i].pos[0][0], portal[i].pos[0][1], portal[i].pos[1][0], portal[i].pos[1][1]);
      }
    }
    SnakeGraphic.strokeWeight(1);
  }
}

/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {                                  //Implement: only draw Food if visible for one snake -> Grid system
  
  
    
  if(shaderOn == true){
    int[] pointX = new int[food.size()];
    int[] pointY = new int[food.size()];
    int[] Glow = new int[food.size()];
    float[] Red = new float[food.size()];
    float[] Green = new float[food.size()];
    float[] Blue = new float[food.size()];
    for(int i=0; i<food.size()-1; i++){
      pointX[i] = food.get(i).posx;
      pointY[i] = food.get(i).posy;
      Red[i] = red(food.get(i).BGcolour);
      Green[i] = green(food.get(i).BGcolour);
      Blue[i] = blue(food.get(i).BGcolour);
    }
    
    FoodShader.set("pointX", pointX); //<>//
    FoodShader.set("pointY", pointY);
    FoodShader.set("Red", Red);
    FoodShader.set("Green", Green);
    FoodShader.set("Blue", Blue);
    FoodShader.set("size", 5); 
    FoodShader.set("Glow", Glow); 
    FoodShader.set("numberFood", food.size()); 
    SnakeGraphic.shader(FoodShader);
  }
  
  for (int i=0; i<food.size(); i++) {
    if (food.get(i).size == 30 && shaderOn == false) {                //if food has no rays on it
      //drawGradient(food.get(i).posx, food.get(i).posy, food.get(i).size);    //draw a circle with blurry circumfence
      if(food.get(i).FoodKind == 0)
        SnakeGraphic.image(i_Food[2],food.get(i).posx - 5, food.get(i).posy - 5);
      else if(food.get(i).FoodKind == 1)
        SnakeGraphic.image(i_Food[4],food.get(i).posx - 5, food.get(i).posy - 5);
      else if(food.get(i).FoodKind == 2)
        SnakeGraphic.image(i_Food[0],food.get(i).posx - 5, food.get(i).posy - 5);
    } 
    else {          //food is seen by the rays
      if(shaderOn == false){
        int offset = round(food.get(i).size/2);
        //SnakeGraphic.fill(food.get(i).BGcolour);
        //SnakeGraphic.stroke(food.get(i).colour);
        //SnakeGraphic.ellipse(food.get(i).posx, food.get(i).posy, food.get(i).size, food.get(i).size);

      if(food.get(i).FoodKind == 0)
        SnakeGraphic.image(i_Food[3],food.get(i).posx - 5, food.get(i).posy - 5);
      else if(food.get(i).FoodKind == 1)
        SnakeGraphic.image(i_Food[5],food.get(i).posx - 5, food.get(i).posy - 5);
      else if(food.get(i).FoodKind == 2)
        SnakeGraphic.image(i_Food[1],food.get(i).posx - 5, food.get(i).posy - 5);

        food.get(i).colour = 0;                    //resets food to not seen every time
        food.get(i).BGcolour = #00160D;
        food.get(i).size = 30;
      }
    }
  }
  if(shaderOn == true)
    SnakeGraphic.resetShader();
}

/**********************************
 *Draws the gradient of food
 ***********************************/
void drawGradient(float x, float y, int size) {
  SnakeGraphic.noStroke();
  for (int r = size/3; r<=size; r+=size/3) {
    SnakeGraphic.fill(0, 0, 255, 10*(1-(r/size)));
    SnakeGraphic.ellipse(x, y, r, r);
  }
}

/**************************************
 *Draws the Missile
 **************************************/
void DrawMissile() {
  for (Snake s : snake) {
    if (s.missilealive == true) {
      SnakeGraphic.fill(#FF0000);
      SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 3, 3);
      SnakeGraphic.fill(#FFAAAA, 50);
      SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 9, 9);
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
        SnakeGraphic.ellipse(s.path[i].pos[0], s.path[i].pos[1], s.path[i].size, s.path[i].size);
      }
    }
  }
}

/**************************
 *Draws all blocks on screen
 **************************/
void DrawBlocks() {
  
  for (int i=0; i<lvl.count-1; i++) {
    // if (math.checkBoundaries(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size)) {

    //int i = grid.get(grids.get(b)).block.get(c);
    if (blocks.get(i).RayCast == true) {
      if(shaderOn == false){
        SnakeGraphic.noStroke();
        SnakeGraphic.fill(blocks.get(i).colour, 50);
        SnakeGraphic.rect(blocks.get(i).pos[0]-3, blocks.get(i).pos[1]-3, blocks.get(i).size+6, blocks.get(i).size+6);
  
        SnakeGraphic.stroke(1);
        SnakeGraphic.fill(blocks.get(i).colour);
        SnakeGraphic.rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
      }
      blocks.get(i).RayCast = false;
    }
    if(shaderOn == false){
      SnakeGraphic.fill(blocks.get(i).colour, blocks.get(i).fade);
      SnakeGraphic.stroke(1);
      SnakeGraphic.rect(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size, blocks.get(i).size);
    }
    blocks.get(i).fade= max(blocks.get(i).fade-10, 0);
    blocks.get(i).outofBounds = false;
    // }

    // else{
    //  blocks.get(i).outofBounds = true;
    //}
  }
}

/*******************************
*Draws the specials on screen
*******************************/
void DrawSpecial() {
  if (specials.size()==0)
    return;
  for (Special special : specials) {
    // if (math.checkBoundaries(special.pos[0], special.pos[1], special.size)) {
    String path = "";
    if (isAndroid == false)
      path = "/data/";
    PImage img = loadImage(path + "img/special_rocket.png");
    if (special.Specialvalue == 0)
      img = loadImage(path + "img/special_rocket.png");
    else if (special.Specialvalue == 1)
      img = loadImage(path + "img/speed.png");
    else if (special.Specialvalue == 2)
      img = loadImage(path + "img/miniSnake.png");
    else if (special.Specialvalue == 3)
      img = loadImage(path + "img/special_dist.png");
    else if (special.Specialvalue == 4)
      img = loadImage(path + "img/special_widening.png");
    else if (special.Specialvalue == 5)
      img = loadImage(path + "img/glow.png");
    SnakeGraphic.fill(0);
    SnakeGraphic.ellipse(special.pos[0], special.pos[1], special.size, special.size);
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

/***************************
*Draws MultiSeperation lines
****************************/
void DrawMultiSep() {
  stroke(0);
  if (NumberPlayer == 1)
    return;
  line(width/2, 0, width/2, height);
  if (NumberPlayer >=3)
    line(0, height/2, width, height/2);
}


/******************
*Draws the canvas
******************/
void DrawCanvas(int count, int h) {
  count = 0;
  int h2 = height/2;
  for (int Player=0; Player<NumberPlayer; Player++) {
    if (NumberPlayer >1)
      translateMultiplayer(Player, count, h);                //left snake left side, right snake right side
    
    if(NumberPlayer ==1){
       image(SnakeGraphic,                                    //Draws the Snake
         0,0,width,height);
       image(pg_Lines,                                       //Draws the Lines on Screen
         0,0,width,height);
       
       /*************** middle left ***********/
       if(snake[0].body.get(0).pos[0] < width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           -width,0,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           -width,0,width,height);
       }
       /*************** middle right ***********/
       if(snake[0].body.get(0).pos[0] > width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           width,0,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           width,0,width,height);
       }
       /*************** top middle ***********/
       if(snake[0].body.get(0).pos[1] < height/2){
         image(SnakeGraphic,                                    //Draws the Snake
           0,-height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           0,-height,width,height);
       }
       /*************** bottom middle ***********/
       if(snake[0].body.get(0).pos[1] > height/2){
         image(SnakeGraphic,                                    //Draws the Snake
           0,height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           0,height,width,height);
       }
       /*************** top left ***********/
       if(snake[0].body.get(0).pos[1] < height/2 && snake[0].body.get(0).pos[0] < width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           -width,-height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           -width,-height,width,height);
       }
       /*************** top right ***********/
       if(snake[0].body.get(0).pos[1] < height/2 && snake[0].body.get(0).pos[0] > width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           width,-height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           width,-height,width,height);
       }
       /*************** bottom left ***********/
       if(snake[0].body.get(0).pos[1] > height/2 && snake[0].body.get(0).pos[0] < width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           -width,height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           -width,height,width,height);
       }
       /*************** bottom right ***********/
       if(snake[0].body.get(0).pos[1] > height/2 && snake[0].body.get(0).pos[0] > width/2){
         image(SnakeGraphic,                                    //Draws the Snake
           width,height,width,height);
         image(pg_Lines,                                       //Draws the Lines on Screen
           width,height,width,height);
       }
    }
    else{
      image(SnakeGraphic.get(
      snake[Player].body.get(0).pos[0]-width/4,
      snake[Player].body.get(0).pos[1]-height/2,
      width/2, height),
      snake[Player].body.get(0).pos[0]-width/4*Zoom,
      snake[Player].body.get(0).pos[1]-h2*Zoom,
      Zoom*width/2, Zoom*height);
    }
    //image(SnakeGraphic,
    //  mouseX-width/2,
    //  mouseY-h2);

    popMatrix();
    if (NumberPlayer != 1)
      popMatrix();
    count ++;
    if (count >=2)
      h2=0;
  }
}
