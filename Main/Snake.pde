/****************************************** //<>// //<>//
 *Handles all about Snakes
 ******************************************/
class Snake extends PrimalSnake {
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
    NPC = dummy;
    id = _id;
    flash = new FlashLight(id);
    for (int i=0; i<=SLength; i++) {
      body.add(new SnakeBody());
    }
    body.get(0).pos[0] = int(random(width));
    body.get(0).pos[1] = int(random(height));
    SnakeSetup(id);
  }
  Snake(boolean dummy, int x, int y, int _id) {
    NPC = dummy;
    id = _id;
    flash = new FlashLight(id);
    for (int i=0; i<=SLength; i++) {
      body.add(new SnakeBody());
    }
    body.get(0).pos[0] = x;
    body.get(0).pos[1] = y;
    SnakeSetup(id);
  }

  //-------------------------------------------------------------------------------------------------------------------
  void SnakeSetup(int ids) {
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
    testFood();
    testSnake();
    testBlocks();
    if (lvl.setPortal)
      testPortal();
    testWalls();
    testUpgrade();
   // GlowHandler();
  }

  @Override
    public void testFood() {
    //TestFood
    float nearestDist =999;

    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(GridSize, id);

    //searches for the nearest food
    //eats it if its close enough
    for (int g = 0; g< gridIDs.size(); g++) {      //each grid test
      for (int f = 0; f< grid.get(gridIDs.get(g)).food.size(); f++) {      //each food in each grid
        int foodID = grid.get(gridIDs.get(g)).food.get(f);
        float distance = findFood(gridIDs, g, f, foodID);
        if (distance < nearestDist) {
          nearestDist = distance;
          nearestFood = food.get(foodID);
        }
      }
    }
  }

  //-------------------------------------------------------------------------------------------------------------------
  float findFood(ArrayList <Integer> gridIDs, int g, int f, int foodID) {
    float distance = sqrt((food.get(foodID).posx-newpos[0])*(food.get(foodID).posx-newpos[0])+(food.get(foodID).posy-newpos[1])*(food.get(foodID).posy-newpos[1]));
    if (distance >= (food.get(foodID).size+size)/2)
      return distance;
    for (int k=0; k<food.get(foodID).value; k++)
      body.add(new SnakeBody(body.get(body.size()-3).pos[0], body.get(body.size()-3).pos[1]));
    if (food.get(foodID).value == 0) {     //Upgrade to be made
      upgrades.PreUpdate();
    } else {
      SLength+=food.get(foodID).value;
      maxFood+=food.get(foodID).value;
    }
    food.get(foodID).reset();
    grid.get(gridIDs.get(g)).food.remove(f);
    fillGridsFood();
    DrawFood();
    return distance;
  }

  void testUpgrade() {
    for (int i=0; i<specials.size(); i++) {
      int maxdist = size/2+specials.get(i).size/2;
      float distance = 999;
      distance = sqrt((specials.get(i).pos[0]-newpos[0])*(specials.get(i).pos[0]-newpos[0])+(specials.get(i).pos[1]-newpos[1])*(specials.get(i).pos[1]-newpos[1]));
      if (distance < maxdist) {
        upgrades.addUpgrade(i);
        specials.remove(i);
        return;
      }
    }
  }

  void testSnake() {
    //testSnake
    for (Snake s : snake) {
      int maxdist = round(size*0.5);
      for (int b = 0; b<s.SLength; b++) {
        float distance = dist(s.body.get(b).pos[0], s.body.get(b).pos[1], newpos[0], newpos[1]);
        // float distance =  sqrt((s.body.get(b).pos[0]-newpos[0])*(s.body.get(b).pos[0]-newpos[0])+(s.body.get(b).pos[1]-newpos[1])*(s.body.get(b).pos[1]-newpos[1]));
        if (distance < maxdist) {    //snek eats snek
          dead = true;
          println("Snake bit snake");
          return;
        } else {                        //check how many bodyparts cannot contact snek  //TODO: auch teleporter und walls in minimum length einbeziehen
          if (dist(s.body.get(b).pos[0], s.body.get(b).pos[1], s.body.get(b).pos[0], 0) < distance) {
          }  //upper wall
          else if (dist(s.body.get(b).pos[0], s.body.get(b).pos[1], 0, s.body.get(b).pos[1]) < distance) {
          }  //left wall
          else if (dist(s.body.get(b).pos[0], s.body.get(b).pos[1], width, s.body.get(b).pos[1]) < distance) {
          }  //right wall
          else if (dist(s.body.get(b).pos[0], s.body.get(b).pos[1], s.body.get(b).pos[0], height) < distance) {
          }  //lower wall
          //else{
          //  b+= floor(distance/size);
          //}
        }
      }
    }
  }

  void testBlocks() {
    //testBlocks
    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(GridSize, id);

    for (int b = 0; b< gridIDs.size(); b++) {      //each grid test
      for (int c = 0; c< grid.get(gridIDs.get(b)).block.size(); c++) {      //each block in each grid
        //for(int i=0;i<lvl.blocksize/2-1;i++){
        int i = grid.get(gridIDs.get(b)).block.get(c);
        if (newpos[0]+size/2>=blocks.get(i).pos[0] && newpos[0]-size/2 <= blocks.get(i).pos[0] + blocks.get(i).size && newpos[1]+size/2>=blocks.get(i).pos[1] && newpos[1] -size/2 <= blocks.get(i).pos[1] + blocks.get(i).size) {
          dead = true;
          println("snake bit block #"+i+"  x:"+blocks.get(i).pos[0]+" y:"+blocks.get(i).pos[1]);
          return;
        }
        //}
      }
    }
  }

  void testPortal() {
    //testPortal
    if (portaltime > 3) {
      for (byte k=0; k<MaxPortals; k++) {
        float[] distance = new float[2];
        boolean teleported = false;
        for (int i=0; i<2; i++) {
          if (teleported==false) {
            distance[i] = abs(dist(portal[k].pos[i][0], portal[k].pos[i][1], newpos[0], newpos[1]));
            if (distance[i] < (size+portal[k].size*sqrt(2))/2 ) {
              if (newpos[0]+size/2 > portal[k].pos[i][0]-portal[k].size/4 && newpos[0]-size/2 <= portal[k].pos[i][0]+portal[k].size/4 && newpos[1]+size/2 > portal[k].pos[i][1]-portal[k].size/2 && newpos[1]-size/2 <= portal[k].pos[i][1]+portal[k].size/2) {
                teleport(portal[k].pos[1-i][0], portal[k].pos[1-i][1]);
                portaltime = 0;
                teleported = true;
              }
            }
          }
        }
      }
    }
    if (portaltime <=3                      )
      portaltime ++;
  }

  void GlowHandler() {
    ArrayList <Integer> gridIDs = new ArrayList <Integer>();
    gridIDs = FindGrid(upgrades.glow, id);
    for (int i = 0; i<body.size(); i+=3) {
      for (int b = 0; b< gridIDs.size(); b++) {      //each grid test
        for (int c = 0; c< grid.get(gridIDs.get(b)).block.size(); c++) {      //each food in each grid
          int j = grid.get(gridIDs.get(b)).block.get(c);
          int distance = int(dist(body.get(i).pos[0], body.get(i).pos[1], blocks.get(j).pos[0], blocks.get(j).pos[1])-body.get(i).size-blocks.get(j).size);
          if (distance <= upgrades.glow) {
            blocks.get(j).RayCast = true;
            blocks.get(j).fade = 255;
            stroke(#FF5555, 150);
          }
        }
        for (int c = 0; c< grid.get(gridIDs.get(b)).food.size(); c++) {      //each food in each grid
          int j = grid.get(gridIDs.get(b)).food.get(c);

          int distance = int(dist(body.get(i).pos[0], body.get(i).pos[1], food.get(j).posx, food.get(j).posy))-food.get(j).size;
          if (distance <= upgrades.glow) {
            food.get(j).init();
            stroke(#5555FF, 150);
          }
        }
      }
    }
  }
}
