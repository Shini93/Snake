//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
/**************************************
 *Draws the bodypart of each given snake
 **************************************/
void drawBody(int Player, int bodyPart, int sizeBody, float stcol, color snekColor) {
  //log.append("drawBody");
  //draws snakebodypart
  SnakeGraphic.fill(snekColor, 255);
  SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos.x, snake[Player].body.get(bodyPart).pos.y, sizeBody, sizeBody);

  //snake "touches" top
  if (snake[Player].body.get(bodyPart).pos.y-snake[Player].size < 0) {
    SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos.x, worldSize.y+snake[Player].body.get(bodyPart).pos.y, sizeBody, sizeBody);
    //snake "touches" bottom
  } else if (snake[Player].body.get(bodyPart).pos.y+snake[Player].size > worldSize.y) {
    SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos.x, snake[Player].body.get(bodyPart).pos.y - worldSize.y, sizeBody, sizeBody);
    //Snake "touches" left
  }
  if (snake[Player].body.get(bodyPart).pos.x-snake[Player].size <0) {
    SnakeGraphic.ellipse(worldSize.x + snake[Player].body.get(bodyPart).pos.x, snake[Player].body.get(bodyPart).pos.y, sizeBody, sizeBody);
    //Snake "touches" right
  } else if (snake[Player].body.get(bodyPart).pos.x+snake[Player].size > worldSize.x) {
    SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos.x - worldSize.x, snake[Player].body.get(bodyPart).pos.y, sizeBody, sizeBody);
  }
  ////draws glow around snake
  //SnakeGraphic.fill(snake[Player].BodyColour(bodyPart), 40);
  //SnakeGraphic.noStroke();
  //SnakeGraphic.ellipse(snake[Player].body.get(bodyPart).pos.x, snake[Player].body.get(bodyPart).pos.y, /*sizeBody+10+sqrt(*/snake[Player].upgrades.glow, /*sizeBody+10+sqrt(*/snake[Player].upgrades.glow);
  //SnakeGraphic.stroke(1);
  snake[Player].body.get(bodyPart).size = snake[Player].size;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*****************************
 *Draws the body of mini snakes
 *****************************/
void drawBodyMini(miniSnake mini, int j) {
  //log.append("drawBodyMini");
  SnakeGraphic.fill(mini.BodyColour(j), 255);
  SnakeGraphic.stroke(#000000);
  SnakeGraphic.ellipse(mini.body.get(j).pos.x, mini.body.get(j).pos.y, mini.size, mini.size);
  SnakeGraphic.fill(mini.BodyColour(j), 40);
  SnakeGraphic.noStroke();
  SnakeGraphic.ellipse(mini.body.get(j).pos.x, mini.body.get(j).pos.y, mini.size+5, mini.size+5);
  SnakeGraphic.stroke(1);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws the Snake(s)
 **********************************/
void DrawSnake() {
  //log.append("DrawSnake");
  for (int Player=0; Player<snake.length; Player++) {
    if (snake[0].dead==true) {
      //lvls.reset();
      return;
    }
    int sizeBody = snake[Player].size;
    if (shaderOn == true) {
    } else {
      if (debugView == false)
        drawSnakeBody(Player, sizeBody);
    }
    for (int m = 0; m < 2; m++) {
      if (snake[Player].upgrades.miniSnake[m] == false)
        continue;
      if (shaderOn == true) {
      } else {
        drawMiniSnake(Player, m);
      }
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws Cursor for Handheld on screen
 ************************************/
void DrawCursor() {
  //log.append("DrawCursor");
  if (isAndroid == false)
    return;
  androidPause.DrawButton();
  if (snake[0].upgrades.speed == true)
    androidSpeed.DrawButton();
  if (snake[0].upgrades.missile == true)
    androidRocket.DrawButton();
  if (mousePressed == false)
    return;
  androidSpeedOn = androidSpeed.isFired();
  println("androidspeed = "+androidSpeedOn);
  
  if (gamePause == false)
    DrawCircleFinger();          //Draws Circle on screen
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/********************************************
 *Draws Circle on Screen when touched (Android)
 *********************************************/
void DrawCircleFinger() {
  //log.append("DrawCircleFinger");
  //dWidth-200, dHeight-200, 100, 100
  if (snake[0].upgrades.speed == true || snake[0].upgrades.missile == true) {
    if (mousepos.x <  200 )
      return;
    if (mousepos.y <  200 )
      return;
  }
  int circleSize = 300;
  int x = 0;
  int y = 0;
  noFill();
  circle(mousepos.x, mousepos.y, circleSize);    //circle for mousemove
  if (dist(mousepos.x, mousepos.y, mouseX, mouseY)>circleSize/2) {    //too far away, gets cut to the right distance
    x = int((-mousepos.x+mouseX)*0.5*circleSize/dist(mousepos.x, mousepos.y, mouseX, mouseY)+mousepos.x);
    y = int((-mousepos.y+mouseY)*0.5*circleSize/dist(mousepos.x, mousepos.y, mouseX, mouseY)+mousepos.y);
  } else {
    x = mouseX;
    y = mouseY;
  }
  stroke(255);
  fill(255);
  circle(x, y, 50);
  AndroidAngle = math.Anglecalc(mousepos.x, mousepos.y, x, y);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**************************************
 *Draws Glowradius from Snake on screen
 ***************************************/
void DrawGlow() {
  for (int Player=0; Player<NumberPlayer; Player++) {
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
      int x1 = int(snake[Player].body.get(0).pos.x);
      int y1 = int(snake[Player].body.get(0).pos.y);
      //int x2 = int(x1+snake[Player].upgrades.glow*math.sinAlike(snake[0].Angle-i*PI/10));
      // int y2 = int(y1-snake[Player].upgrades.glow*math.cosAlike(snake[0].Angle-i*PI/10));
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(snake[Player].Angle-i*PI/10), y1-snake[Player].upgrades.glow*math.cosS(snake[Player].Angle-i*PI/10));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(snake[Player].Angle-i*PI/10), y1-0.5*snake[Player].upgrades.glow*math.cosS(snake[Player].Angle-i*PI/10));
    }
    for (int i=0; i<snake[Player].body.size()-1; i++) {
      int x1 = int(snake[Player].body.get(i).pos.x);
      int y1 = int(snake[Player].body.get(i).pos.y);
      int x2 = int(snake[Player].body.get(i+1).pos.x);
      int y2 = int(snake[Player].body.get(i+1).pos.y);
      float Angle = math.Anglecalc(x1, y1, x2, y2);

      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(Angle), y1-snake[Player].upgrades.glow*cos(Angle));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(Angle), y1-0.5*snake[Player].upgrades.glow*math.cosS(Angle));
    }
    for (int i= 10; i>=0; i--) {
      int x1 = int(snake[Player].body.get(snake[Player].body.size()-1).pos.x);
      int y1 = int(snake[Player].body.get(snake[Player].body.size()-1).pos.y);
      int x2 = int(snake[Player].body.get(snake[Player].body.size()-2).pos.x);
      int y2 = int(snake[Player].body.get(snake[Player].body.size()-2).pos.y);
      float Angle = math.Anglecalc(x1, y1, x2, y2);
      glowShape.vertex(x1+snake[Player].upgrades.glow*math.sinS(Angle+i*PI/10), y1-snake[Player].upgrades.glow*math.cosS(Angle+i*PI/10));
      glowShapeInner.vertex(x1+0.5*snake[Player].upgrades.glow*math.sinS(Angle+i*PI/10), y1-0.5*snake[Player].upgrades.glow*math.cosS(Angle+i*PI/10));
    }
    for (int i=snake[Player].body.size()-1; i>1; i--) {
      int x1 = int(snake[Player].body.get(i).pos.x);
      int y1 = int(snake[Player].body.get(i).pos.y);
      int x2 = int(snake[Player].body.get(i-1).pos.x);
      int y2 = int(snake[Player].body.get(i-1).pos.y);
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

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws the Portal(s)
 **********************************/
void DrawEllipse(int x, int y, float size, int weight, color colour, int opa, color fill) {
  //log.append("DrawEllipse");
  SnakeGraphic.strokeWeight(weight);
  SnakeGraphic.stroke(colour, opa);
  SnakeGraphic.ellipse(x, y, size*0.5+2, size+4);
  SnakeGraphic.stroke(colour);
  SnakeGraphic.fill(fill);
  SnakeGraphic.ellipse(x, y, size*0.5, size);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void DrawPortal() {
  //log.append("DrawPortal");
  if (lvl.setPortal == false)
    return;
  for (byte i=0; i<MaxPortals; i++) {      //repeat for every portal in existance
    color teleCol = color(255*noise(100*i), 255*noise(125*(i+1)), 255*noise(175*(i+3)));
    DrawEllipse(portal[i].pos[0][0]-round(portal[i].size*0.25), portal[i].pos[0][1] - round(portal[i].size*0.5), portal[i].size, 2, portal[i].colour1, 30, teleCol);      //Draws Portal
    DrawEllipse(portal[i].pos[1][0]-round(portal[i].size*0.25), portal[i].pos[1][1] - round(portal[i].size*0.5), portal[i].size, 2, portal[i].colour2, 30, teleCol);

    //GridSystem einpflegen, nur abfragen, wenn snake nah genug an einem der beiden Portale ist!
    boolean near = false;
    float distance = 9999;

    /*Line appers which connects the 2 portals, if one snake is close enough*/
    for (Snake s : snake) {
      if (dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[1][0], portal[i].pos[1][1]) < 100) {
        near = true;
        if (dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[1][0], portal[i].pos[1][1])<distance)
          distance = dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[1][0], portal[i].pos[1][1]);
      } else if (dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[0][0], portal[i].pos[0][1]) < 100)
        near = true;
      if (dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[0][0], portal[i].pos[0][1])<distance)
        distance = dist(s.body.get(0).pos.x, s.body.get(0).pos.y, portal[i].pos[0][0], portal[i].pos[0][1]);
    }
    if (near == false)
      continue;
    SnakeGraphic.stroke(#00FFFF, 2550/((distance+1)));
    SnakeGraphic.line(portal[i].pos[0][0] - round(portal[i].size*0.25), portal[i].pos[0][1]- round(portal[i].size*0.5), portal[i].pos[1][0]- round(portal[i].size*0.25), portal[i].pos[1][1] - round(portal[i].size*0.5));
  }
  SnakeGraphic.strokeWeight(1);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws Food Shader on Screen
 **********************************/
void drawFoodShader() {
  //log.append("drawFoodShader");
  if (shaderOn == true) {
    int[] pointX = new int[food.size()];
    int[] pointY = new int[food.size()];
    int[] Glow = new int[food.size()];
    float[] Red = new float[food.size()];
    float[] Green = new float[food.size()];
    float[] Blue = new float[food.size()];

    for (int i=0; i<food.size()-1; i++) {
      pointX[i] = round(food.get(i).pos.x);
      pointY[i] = round(food.get(i).pos.y);
      Red[i] = red(food.get(i).BGcolour);
      Green[i] = green(food.get(i).BGcolour);
      Blue[i] = blue(food.get(i).BGcolour);
    }

    FoodShader.set("pointX", pointX);
    FoodShader.set("pointY", pointY);
    FoodShader.set("Red", Red);
    FoodShader.set("Green", Green);
    FoodShader.set("Blue", Blue);
    FoodShader.set("size", 5);
    FoodShader.set("Glow", Glow);
    FoodShader.set("numberFood", food.size());
    SnakeGraphic.shader(FoodShader);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws Food and other lvl ups
 **********************************/
void DrawFood() {                                  //Implement: only draw Food if visible for one snake -> Grid system
  //log.append("DrawFood");
  drawFoodShader();
  for (int i=0; i<food.size(); i++) {
    if (food.get(i).size == 30 && shaderOn == false) {                //if food has no rays on it
      if (food.get(i).fade > 0) {
        SnakeGraphic.tint(255, food.get(i).fade);
        drawGradient(food.get(i).pos.x, food.get(i).pos.y, food.get(i).size);    //draw a circle with blurry circumfence
        if (food.get(i).value != 0)
          food.get(i).fade -= 10;
        if (food.get(i).FoodKind == 0)
          SnakeGraphic.image(i_Food[2], food.get(i).pos.x - 5, food.get(i).pos.y - 5);
        else if (food.get(i).FoodKind == 1)
          SnakeGraphic.image(i_Food[4], food.get(i).pos.x - 5, food.get(i).pos.y - 5);
        else if (food.get(i).FoodKind == 2)
          SnakeGraphic.image(i_Food[0], food.get(i).pos.x - 5, food.get(i).pos.y - 5);
        SnakeGraphic.tint(255, 255);
      }
    } else {          //food is seen by the rays
      if (shaderOn == false && food.get(i).fade > 0) {
        //int offset = round(food.get(i).size/2);
        //SnakeGraphic.fill(food.get(i).BGcolour);
        //SnakeGraphic.stroke(food.get(i).colour);
        //SnakeGraphic.ellipse(food.get(i).posx, food.get(i).posy, food.get(i).size, food.get(i).size);
        if (food.get(i).FoodKind == 0)
          SnakeGraphic.image(i_Food[3], food.get(i).pos.x - 5, food.get(i).pos.y - 5);
        else if (food.get(i).FoodKind == 1)
          SnakeGraphic.image(i_Food[5], food.get(i).pos.x - 5, food.get(i).pos.y - 5);
        else if (food.get(i).FoodKind == 2)
          SnakeGraphic.image(i_Food[1], food.get(i).pos.x - 5, food.get(i).pos.y - 5);

        food.get(i).colour = 0;                    //resets food to not seen every time
        food.get(i).BGcolour = #00160D;
        food.get(i).size = 30;        //
      }
    }
  }
  if (shaderOn == true)
    SnakeGraphic.resetShader();
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**********************************
 *Draws the gradient of food
 ***********************************/
void drawGradient(float x, float y, int size) {
  //log.append("drawGradient");
  SnakeGraphic.noStroke();
  for (int r = size/3; r<=size; r+=size/3) {
    SnakeGraphic.fill(0, 0, 255, 10*(1-(r/size)));
    SnakeGraphic.ellipse(x, y, r, r);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**************************************
 *Draws the Missile
 **************************************/
void DrawMissile() {
  //log.append("DrawMissile");
  for (Snake s : snake) {
    if (s.missilealive == false)
      continue;
    SnakeGraphic.fill(#FF0000);
    SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 3, 3);
    SnakeGraphic.fill(#FFAAAA, 50);
    SnakeGraphic.ellipse(s.missile.pos[0], s.missile.pos[1], 9, 9);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**************************************
 *Draws the Path of the Missile
 **************************************/
void DrawPath() {
  //log.append("DrawPath");
  for (Snake s : snake ) {
    if (s == null || s.missile == null || s.missile.alive ==0)
      return;
    s.path[s.missile.alive-1] = new MissilePath(s.missile.pos[0], s.missile.pos[1]);
    for (int i=0; i<s.missile.alive-1; i++) {
      if (s.path[i].alive < 0)
        continue;
      SnakeGraphic.fill(#FFFFFF, s.path[i].fade);
      SnakeGraphic.ellipse(s.path[i].pos[0], s.path[i].pos[1], s.path[i].size, s.path[i].size);
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**************************
 *Draws all blocks on screen
 **************************/
void DrawBlocks() {
  //log.append("DrawBlocks");
  for (int i=0; i<lvl.count-1; i++) {
    // if (math.checkBoundaries(blocks.get(i).pos[0], blocks.get(i).pos[1], blocks.get(i).size)) {
    //int i = grid.get(grids.get(b)).block.get(c);
    if (blocks.get(i).RayCast == true) {
      if (shaderOn == true) {
        SnakeGraphic.noStroke();
        SnakeGraphic.fill(blocks.get(i).colour, 50);
        SnakeGraphic.rect(blocks.get(i).pos.x-blocks.get(i).size/2, blocks.get(i).pos.y-blocks.get(i).size/2, blocks.get(i).size+6, blocks.get(i).size+6);

        SnakeGraphic.stroke(1);
        SnakeGraphic.fill(blocks.get(i).colour);
        SnakeGraphic.rect(blocks.get(i).pos.x, blocks.get(i).pos.y, blocks.get(i).size, blocks.get(i).size);
      }
      blocks.get(i).RayCast = false;
    }
    if (shaderOn == false && blocks.get(i).fade > 0) {
      SnakeGraphic.fill(blocks.get(i).colour, blocks.get(i).fade);
      SnakeGraphic.stroke(1);
      SnakeGraphic.rect(blocks.get(i).pos.x, blocks.get(i).pos.y, blocks.get(i).size, blocks.get(i).size);
    }
    blocks.get(i).fade= max(blocks.get(i).fade-10, 0);
    blocks.get(i).outofBounds = false;
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*******************************
 *Draws the specials on screen
 *******************************/
void DrawSpecial() {
  //log.append("DrawSpecial");
  if (specials.size()==0)
    return;
  for (Special special : specials) {
    // if (math.checkBoundaries(special.pos[0], special.pos[1], special.size)) {
    String path = "img/";
    if (isAndroid == false)
      path = "/data/img/";
    String[] imgName = {"special_rocket", "speed", "miniSnake", "special_dist", "special_widening", "glow", "magnet", "laterne"};
    PImage img = loadImage(path + imgName[special.Specialvalue] + ".png");
    SnakeGraphic.fill(0);
    SnakeGraphic.ellipse(special.pos.x, special.pos.y, special.size, special.size);
    img.resize(special.size, special.size);
    SnakeGraphic.image(img, special.pos.x-special.size/2, special.pos.y-special.size/2);
    // }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*******************************
 *Draws the specials on screen
 *******************************/
void DrawLanterns() {
  //log.append("DrawSpecial");
  if (laternen.size() <= 0)
    return;
  for (int l = 0; l < laternen.size(); l++) {
    laternen.get(l).drawOnScreen();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/**************************
 *Draws all Text on screen
 **************************/
void DrawText() {
  //log.append("DrawText");
  textSize(30);
  String text = "maxFood: "+ maxFood +"\n";
  text += "Snake Size: "+snake[0].SLength;
  text += "\nwinSize :"+lvl.winsize;
  text(text, 150, 150);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/***************************
 *Draws MultiSeperation lines
 ****************************/
void DrawMultiSep() {
  //log.append("DrawMultiSep");
  stroke(0);
  if (NumberPlayer == 1)
    return;
  line(dWidth/2, 0, dWidth/2, dHeight);
  if (NumberPlayer >=3)
    line(0, dHeight/2, dWidth, dHeight/2);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/******************
 *Draws the canvas
 ******************/
void DrawCanvas(int count, int h) {
  //log.append("DrawCanvas");
  count = 0;
  int h2 = round(worldSize.y/2);
  for (int Player=0; Player<NumberPlayer; Player++) {
    if (NumberPlayer >1)
      translateMultiplayer(Player, count, h);                //left snake left side, right snake right side

    //Make copies of the screen on all adjentand tiles
    if (NumberPlayer ==1) {
      //middle
      imageAll(0, 0, worldSize.x, worldSize.y);

      //only if size is smaller then screen
      if (worldSize.x < dWidth ) {
        imageAll(-worldSize.x, 0, worldSize.x, worldSize.y);
        imageAll(worldSize.x, 0, worldSize.x, worldSize.y);
      }
      if (worldSize.y < dHeight) {
        imageAll(0, -worldSize.y, worldSize.x, worldSize.y);
        imageAll(0, worldSize.y, worldSize.x, worldSize.y);
      }
      if (worldSize.y < dHeight && worldSize.x < dWidth) {
        imageAll(-worldSize.x, -worldSize.y, worldSize.x, worldSize.y);
        imageAll(worldSize.x, -worldSize.y, worldSize.x, worldSize.y);
        imageAll(worldSize.x, worldSize.y, worldSize.x, worldSize.y);
        imageAll(-worldSize.x, worldSize.y, worldSize.x, worldSize.y);
      }
      //-------------------------------------------------------------------------------
      PVector snek = new PVector(snake[0].body.get(0).pos.x, snake[0].body.get(0).pos.y);
      /*************** middle left ***********/
      if (snek.x < worldSize.x/2 ) {
        imageAll(-worldSize.x, 0, worldSize.x, worldSize.y);
      }
      /*************** middle right ***********/
      if (snek.x > worldSize.x/2) {
        imageAll(worldSize.x, 0, worldSize.x, worldSize.y);
      }
      //-------------------------------------------------------------------------------
      /*************** top middle ***********/
      if (snek.y < worldSize.y/2) {
        imageAll(0, -worldSize.y, worldSize.x, worldSize.y);
      }
      /*************** top left ***********/
      if (snek.y < worldSize.y/2 && snek.x < worldSize.x/2) {
        imageAll(-worldSize.x, -worldSize.y, worldSize.x, worldSize.y);
      }
      /*************** top right ***********/
      if (snek.y < worldSize.y/2 && snek.x > worldSize.x/2) {
        imageAll(worldSize.x, -worldSize.y, worldSize.x, worldSize.y);
      }
      //-------------------------------------------------------------------------------
      /*************** bottom middle ***********/
      if (snek.y > worldSize.y/2) {
        imageAll(0, worldSize.y, worldSize.x, worldSize.y);
      }
      /*************** bottom left ***********/
      if (snek.y > worldSize.y/2 && snek.x < worldSize.x/2) {
        imageAll(-worldSize.x, worldSize.y, worldSize.x, worldSize.y);
      }
      /*************** bottom right ***********/
      if (snek.y > worldSize.y/2 && snek.x > worldSize.x/2) {
        imageAll(worldSize.x, worldSize.y, worldSize.x, worldSize.y);
      }
    } else {
      image(SnakeGraphic.get(
        round(snake[Player].body.get(0).pos.x-worldSize.x/4),
        round(snake[Player].body.get(0).pos.y-worldSize.y/2),
        round(worldSize.x/2), round(worldSize.y)),
        snake[Player].body.get(0).pos.x-worldSize.x/4*Zoom,
        snake[Player].body.get(0).pos.y-h2*Zoom,
        Zoom*worldSize.x/2, Zoom*worldSize.y);
    }
    //image(SnakeGraphic,
    //  mouseX-dWidth/2,
    //  mouseY-h2);

    popMatrix();
    if (NumberPlayer != 1)
      popMatrix();
    count ++;
    if (count >=2)
      h2=0;
  }
}
void imageAll(int x, int y, int w, int h) {
  //log.append("imageAll");
  image(SnakeGraphic, //Draws the Snake
    x, y, w, h);
  image(pg_Lines, //Draws the Lines on Screen
    x, y, w, h);
}
void imageAll(float x, float y, float w, float h) {
  //log.append("imageAll");
  image(SnakeGraphic, //Draws the Snake
    x, y, w, h);
  image(pg_Lines, //Draws the Lines on Screen
    x, y, w, h);
}

void DrawFlash() {
  //log.append("DrawFlash");
  for (Snake s : snake) {
    s.flash.update();
    int x = int(s.body.get(0).pos.x);
    int y = int(s.body.get(0).pos.y);

    //mitte rechts
    if (x + s.flash.sizeFlash > worldSize.x) {
      s.flash.drawLight(x-worldSize.x, y);
      s.flash.findBlocks(x-worldSize.x, y);

      //oben rechts
      if (y - s.flash.sizeFlash < 0) {
        s.flash.drawLight(x-worldSize.x, worldSize.y + y );
        s.flash.findBlocks(x-worldSize.x, worldSize.y + y);
      }
      //unten rechts
      if (y + s.flash.sizeFlash > worldSize.y) {
        s.flash.drawLight(x-worldSize.x, y - worldSize.y);
        s.flash.findBlocks(x-worldSize.x, y - worldSize.y);
      }
    }
    //mitte links
    if (x - s.flash.sizeFlash < 0) {
      s.flash.drawLight(worldSize.x+x, y);
      s.flash.findBlocks(worldSize.x+x, y);

      //oben links
      if (y - s.flash.sizeFlash < 0) {
        s.flash.drawLight(worldSize.x+x, worldSize.y + y );
        s.flash.findBlocks(worldSize.x+x, worldSize.y + y);
      }
      //unten links
      if (y + s.flash.sizeFlash > worldSize.y) {
        s.flash.drawLight(worldSize.x+x, y - worldSize.y);
        s.flash.findBlocks(worldSize.x+x, y - worldSize.y);
      }
    }
    //unten mitte
    if (y + s.flash.sizeFlash > worldSize.y) {
      s.flash.drawLight(x, y-worldSize.y);
      s.flash.findBlocks(x, y-worldSize.y);
    }
    //oben mitte
    if (y - s.flash.sizeFlash < 0) {
      s.flash.drawLight(x, worldSize.y+y);
      s.flash.findBlocks(x, worldSize.y+y);
    }
  }
}

void drawMiniSnake(int Player, int m) {
  //log.append("drawMiniSnake");
  for (int j=0; j<snake[Player].mini[m].SLength; j++) {
    drawBodyMini(snake[Player].mini[m], j);
  }
}

void drawSnakeBody(int Player, int sizeBody) {
  //log.append("drawSnakeBody");
  float stcol = min(255, 0.5 * snake[Player].upgrades.glow) ;
  color snekCol = snake[Player].BodyColour(0);
  int modulo = ceil(0.05 * snake[Player].body.size());      //bei länge = 100 soll jedes 5. körperteil ne neue farbe haben (ab dem 100. körperteil

  SnakeGraphic.stroke(stcol, 255);
  for (int bodyPart=0; bodyPart<snake[Player].SLength; bodyPart++) {
    sizeBody = snake[Player].body.get(bodyPart).size;

    if (bodyPart > 100 && bodyPart % modulo == 0) {
      snekCol = snake[Player].BodyColour(bodyPart);
    } else
      snekCol = snake[Player].BodyColour(bodyPart);

    if (isInReach(snake[Player].body.get(0).pos, snake[Player].body.get(bodyPart).pos, 0.5 * dWidth))
      drawBody(Player, bodyPart, sizeBody, stcol, snekCol);
  }
}

float minDistReq(PVector s, PVector b) {
  float minDist = 99999;
  for (int x = -1; x <= 1; x++)
    for (int y = -1; y <= 1; y++)
      minDist = min(minDist, dist(s.x, s.y, b.x + x * worldSize.x, b.y + y * worldSize.y));
  return minDist;
}

Boolean isInReach(PVector s, PVector b, float neededDist) {
  float minDist = 99999;
  for (int x = -1; x <= 1; x++)
    for (int y = -1; y <= 1; y++) {
      minDist = min(minDist, dist(s.x, s.y, b.x + x * worldSize.x, b.y + y * worldSize.y));
      if (minDist <= neededDist)
        return true;
    }
  return false;
}

void DrawBackground() {
  //log.append("DrawBackground");
  if (red(BackgroundColor) <= 0 && green(BackgroundColor) <= 0 && blue(BackgroundColor) <= 0)
    return;
  for (Blocks b : blocks)
    b.fade = 255;
  for (Food f : food)
    f.fade = 255;
  float speedBlack = 0.001;
  float red = red(BackgroundColor) - speedBlack;
  float green = green(BackgroundColor) - speedBlack;
  float blue = blue(BackgroundColor) - speedBlack;
  BackgroundColor = color(red, green, blue);
  if (red < speedBlack || blue < speedBlack || green < speedBlack) {
    BackgroundColor = #000000;
  }
}
