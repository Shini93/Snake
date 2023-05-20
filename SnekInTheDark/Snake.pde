/****************************************** //<>// //<>// //<>// //<>// //<>//
 *Handles all about Snakes
 ******************************************/
class Snake extends PrimalSnake {
  int gridLastFrame = 0;
  int lastGrid = 0;
  boolean missilealive = false;   //No Kaboom anymore
  Missiles missile;               //Kaboom!
  UpgradeHandler upgrades = new UpgradeHandler();
  // Ray[] ray = new Ray[maxRays];
  FlashLight flash;
  miniSnake[] mini = new miniSnake[2];
  MissilePath [] path = new MissilePath [100];  //creates missilepath
  Food nearestFood = new Food(0, 0, -1000, -1000);
  ArrayList <Integer> gridIDsRay = new ArrayList <Integer>();          //RayIDList
  /***************************************
   *Constructor
   ***************************************/
  Snake(boolean dummy, int _id) {
    //log.append("Snake.Snake");
    NPC = dummy;
    id = _id;
    flash = new FlashLight(id);
    for (int i=0; i<=SLength; i++) {
      body.add(new SnakeBody());
    }
    body.get(0).pos.x = int(random(dWidth));
    body.get(0).pos.y = int(random(dHeight));
    SnakeSetup(id);
  }
  Snake(boolean dummy, int x, int y, int _id) {
    //log.append("Snake.Snake");
    NPC = dummy;
    id = _id;
    flash = new FlashLight(id);
    for (int i=0; i<=SLength; i++) {
      body.add(new SnakeBody());
    }
    body.get(0).pos = new PVector(x, y);
    SnakeSetup(id);
  }

  //-------------------------------------------------------------------------------------------------------------------
  void SnakeSetup(int ids) {
    //log.append("Snake.SnakeSetup");
    id = ids;
    upgrades.snakeID = id;
    mini[0] = new miniSnake(1, id);        //ini mini snakes, even if upgrade for minis is not yet set
    mini[1] = new miniSnake(2, id);
    // initRays();
    missile = new Missiles();
    path[0] = new MissilePath();
  }


  /***************************************
   *Tests if the Path is free
   ***************************************/
  @Override
    public void testPath() {
    //log.append("Snake.testPath");
    //if (id == 0) {
    //   thread("testSnekOneFood");
    //thread("testSnekOneBlocks");
    //thread("testSnekOneSnakes");

    //} else {
    //  testFood();
    //}
    if (debugView == false){
      testFood();
      testSnake();
      testBlocks();
    }
    if (lvl.setPortal)
      testPortal();
    testWalls();
    testUpgrade();
    GlowHandler();
    gridLastFrame --;
  }

  @Override
    public void testFood() {
    //TestFood
    //log.append("Snake.testFood");
    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(GridSize, id);

    //searches for the nearest food
    //eats it if its close enough
    for (int g = 0; g< gridIDs.size(); g++) {      //each grid test
      for (int f = 0; f< grid.get(gridIDs.get(g)).food.size(); f++) {      //each food in each grid
        int foodID = grid.get(gridIDs.get(g)).food.get(f);
        float minDist = minDistReq(new PVector(newpos[0], newpos[1]), food.get(foodID).pos);
        findFood(foodID, minDist);
        if (minDist < ((food.get(foodID).size+size)/2) + upgrades.magnetDist ) {
          eatFood(foodID, gridIDs, g, f);
        }
      }
    }
  }



  //-------------------------------------------------------------------------------------------------------------------
  float findFood(int foodID, float distance) {
    //log.append("Snake.findFood");

    // float distance = sqrt((food.get(foodID).posx-newpos[0])*(food.get(foodID).posx-newpos[0])+(food.get(foodID).posy-newpos[1])*(food.get(foodID).posy-newpos[1]));
    if (distance <= upgrades.glow) {
      food.get(foodID).countSnake = SLength;
    }
    flash.findFood(food.get(foodID).pos, distance, foodID);
    return distance;
  }

  void eatFood(int foodID, ArrayList <Integer> gridIDs, int g, int f) {
    for (int k=0; k<food.get(foodID).value; k++)
      body.add(new SnakeBody(body.get(body.size()-3).pos));
    if (food.get(foodID).value == 0) {     //Upgrade to be made
      upgrades.PreUpdate();
    } else {
      SLength+=food.get(foodID).value;
      maxFood+=food.get(foodID).value;
    }
    food.get(foodID).reset();
    grid.get(gridIDs.get(g)).food.remove(f);
    fillGridsFood();
    if (NPC == false) {
    }
    gameSound[0].play();
  }

  void testUpgrade() {
    //log.append("Snake.testUpgrade");
    for (int i=0; i<specials.size(); i++) {
      int maxdist = size/2+specials.get(i).size/2;
      float distance = 999;
      distance = dist(specials.get(i).pos.x, specials.get(i).pos.y, newpos[0], newpos[1]);
      if (distance >= maxdist)
        continue;
      gameSound[1].play();
      upgrades.addUpgrade(i);
      specials.remove(i);
      return;
    }
  }

  void testSnake() {
    //testSnake
    //log.append("Snake.testSnake");
    PVector newposs = new PVector(newpos[0], newpos[1]);
    for (Snake s : snake) {
      int maxdist = round(size*0.5);
      for (int b = 20; b<s.SLength; b++) {
        float minDist = minDistReq(s.body.get(b).pos, newposs);
        if (minDist >= maxdist) {     //snek eats snek
          b += round(minDist/ FieldSize*speedSnake) - 1;
          continue;
        }
        dead = true;
        println("Snake bit snake");
        return;
      }
    }
  }


  void testBlocks() {
    //testBlocks
    //log.append("Snake.testBlocks");
    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(GridSize, id);

    for (int b = 0; b< gridIDs.size(); b++) {      //each grid test
      for (int c = 0; c< grid.get(gridIDs.get(b)).block.size(); c++) {      //each block in each grid
        //for(int i=0;i<lvl.blocksize/2-1;i++){
        int i = grid.get(gridIDs.get(b)).block.get(c);
        float distance = dist(newpos[0], newpos[1], blocks.get(i).pos.x+blocks.get(i).size/2, blocks.get(i).pos.y+blocks.get(i).size/2);
        if (distance <= (size/2)+(blocks.get(i).size/2)) {
          //if (newpos[0]+size/2>=blocks.get(i).pos[0] && newpos[0]-size/2 <= blocks.get(i).pos[0] + blocks.get(i).size && newpos[1]+size/2>=blocks.get(i).pos[1] && newpos[1] -size/2 <= blocks.get(i).pos[1] + blocks.get(i).size) {
          dead = true;
          println("snake bit block #"+i+"  x:"+blocks.get(i).pos.x+" y:"+blocks.get(i).pos.y);
          return;
        }
        if (flash.findBlock(blocks.get(i).pos, distance, i) == false) {
          // continue;
        }
        if (distance > upgrades.glow)
          continue;
        blocks.get(i).countSnake = SLength;
      }
    }
  }

  void testPortal() {
    //log.append("Snake.testPortal");
    //testPortal
    if (portaltime > 3) {
      for (byte k=0; k<MaxPortals; k++) {        //test all portals
        float[] distance = new float[2];
        boolean teleported = false;
        for (int i=0; i<2; i++) {          //test portal combi
          if (teleported==true)
            continue;
          float pSize = portal[k].size*0.5;
          distance[i] = abs(dist(portal[k].pos[i][0] - 0.5*pSize, portal[k].pos[i][1] - pSize, newpos[0], newpos[1]));
          if (distance[i] >= (size+portal[k].size*sqrt(2))/2 )
            continue;
          if (newpos[0]+size/2 <= portal[k].pos[i][0]-portal[k].size/4)
            continue;
          if (newpos[0]-size/2 > portal[k].pos[i][0]+portal[k].size/4)
            continue;
          if (newpos[1]+size/2 <= portal[k].pos[i][1]-portal[k].size/2)
            continue;
          if (newpos[1]-size/2 > portal[k].pos[i][1]+portal[k].size/2)
            continue;
          teleport(portal[k].pos[1-i][0] - portal[k].size*0.25, portal[k].pos[1-i][1] - portal[k].size*0.5);
          portaltime = 0;
          teleported = true;
        }
      }
    }
    if (portaltime <=3                      )
      portaltime ++;
  }

  void GlowHandler() {
    //log.append("Snake.GlowHandler");
    stroke(#FF5555, 150);
    for (Blocks b : blocks) {
      if (b.countSnake>0) {
        b.countSnake--;
        b.RayCast = true;
        b.fade = 255;
      }
    }
    stroke(#5555FF, 150);
    for (Food f : food) {
      if (f.countSnake >0) {
        f.countSnake--;
        f.init();
        f.fade = 255;
      }
    }
  }
  //depricated
  void GlowHandlerOld() {
    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(upgrades.glow, id);
    for (int i = 0; i<body.size(); i+=3) {
      for (int b = 0; b< gridIDs.size(); b++) {      //each grid test
        for (int c = 0; c< grid.get(gridIDs.get(b)).block.size(); c++) {      //each food in each grid
          int j = grid.get(gridIDs.get(b)).block.get(c);
          int distance = int(dist(body.get(i).pos.x, body.get(i).pos.y, blocks.get(j).pos.x, blocks.get(j).pos.y)-body.get(i).size-blocks.get(j).size);
          if (distance <= upgrades.glow) {
            blocks.get(j).RayCast = true;
            blocks.get(j).fade = 255;
            stroke(#FF5555, 150);
          }
        }
        for (int c = 0; c< grid.get(gridIDs.get(b)).food.size(); c++) {      //each food in each grid
          int j = grid.get(gridIDs.get(b)).food.get(c);

          int distance = int(dist(body.get(i).pos.x, body.get(i).pos.y, food.get(j).pos.x, food.get(j).pos.y))-food.get(j).size;
          if (distance <= upgrades.glow) {
            food.get(j).init();
            stroke(#5555FF, 150);
          }
        }
      }
    }
  }
}

//----------------------------------------------------------------------------------------------------------------------------------
class miniSnake extends PrimalSnake {
  int distanceSnake = 30;
  float AngleSnake = 0;
  float distancesindelta = 5;
  float distanceAngledelta = 0;
  int snakeID;
  miniSnake(int side, int snakeNumber) {
    snakeID = snakeNumber;
    SLength = 10;
    for (int i=0; i<=SLength; i++) {
      body.add(new SnakeBody());
    }
    if (side == 1)
      AngleSnake = PI/2;
    else
      AngleSnake = -PI/2;
  }

  @Override
    public void nextTile() {
    //log.append("mini.nextTile");
    body.get(0).pos.x = snake[snakeID].body.get(0).pos.x      //snakeHead Main
      -int((distancesindelta                                    //distance to snakeHead Main
      *math.sinS(distanceAngledelta)+distanceSnake)                //frequency
      *math.cosAlike(snake[snakeID].Angle+AngleSnake));                //which side snaky is at
    body.get(0).pos.y = snake[snakeID].body.get(0).pos.y-int((distancesindelta*math.sinS(distanceAngledelta)+distanceSnake)*math.sinS(snake[snakeID].Angle+AngleSnake));
    distanceAngledelta+=80*PI/360;
  }

  @Override
    public void Calcsize() {
    //log.append("mini.Calcsize");
    size=5;
  }

  @Override
    public void testFood() {
    //TestFood
    //log.append("mini.testFood");
    newpos[0] = int(body.get(0).pos.x);
    newpos[1] = int(body.get(0).pos.y);
    for (Food f : food) {
      float distance = dist(newpos[0], newpos[1], f.pos.x, f.pos.y);
      if (distance >= ((size + f.size)/ 2) + snake[snakeID].upgrades.magnetDist)
        continue;
      gameSound[0].play();
      f.reset();
      body.add(new SnakeBody(new PVector(body.get(0).pos.x, body.get(0).pos.y)));
      SLength ++;
      for (int k=0; k<snake[snakeID].nearestFood.value; k++) {
        snake[snakeID].body.add(new SnakeBody(new PVector(15, 15)));
      }
      if (snake[snakeID].nearestFood.value == 0) {     //Upgrade to be made
        snake[snakeID].upgrades.PreUpdate();
      } else {
        snake[snakeID].SLength+=snake[snakeID].nearestFood.value;
        maxFood+=snake[snakeID].nearestFood.value;
      }
      fillGridsFood();
    }
  }
}
