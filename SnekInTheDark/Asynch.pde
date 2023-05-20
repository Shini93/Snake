void playMusic() {
  String path = "sound/music/";
  String[] musicNamePC = {"Fighting_in_the_dark", "Light Ambient 3 (Loop)", "newlifeinhell", "Night Ambient 5 (Loop)", "SAVED_THE_DAY"};
  String[] musicNameAndroid = {"Light Ambient 3 (Loop)","Night Ambient 5 (Loop)"};
  String[] musicName = musicNamePC;
    if(isAndroid == true)
      musicName = musicNameAndroid;
  music = new SoundFile(this, path + musicName[selectedTrack] + ".wav");
  music.loop();
  musicStopped = false;
}

//asynch task to see if snake 1 dies off
void testSnekOneBlocks() {
  int id = 0;
  int[] newpos = new int[2];
  newpos[0] = snake[0].newpos[0];
  newpos[1] = snake[0].newpos[1];
  ArrayList <Integer> gridIDs = new ArrayList <Integer>();
  gridIDs = FindGrid(GridSize, id);

  for (int b = 0; b< gridIDs.size(); b++) {      //each grid test
    for (int c = 0; c< grid.get(gridIDs.get(b)).block.size(); c++) {      //each block in each grid
      //for(int i=0;i<lvl.blocksize/2-1;i++){
      int i = grid.get(gridIDs.get(b)).block.get(c);
      float distance = dist(newpos[0], newpos[1], blocks.get(i).pos.x+blocks.get(i).size/2, blocks.get(i).pos.y+blocks.get(i).size/2);
      if (distance <= (snake[0].size/2)+(blocks.get(i).size/2)) {
        snake[0].dead = true;
        println("snake bit block #"+i+"  x:"+blocks.get(i).pos.x+" y:"+blocks.get(i).pos.y);
        return;
      }
      if (distance > snake[0].upgrades.glow)
        continue;
      blocks.get(i).countSnake = snake[0].SLength;
    }
  }
}

void testSnekOneSnakesID(int snekID){
   //testSnake
    for (Snake s : snake) {
      int maxdist = round(snake[snekID].size*0.5);
      for (int b = 1; b<s.SLength; b++) {
        float distance = dist(s.body.get(b).pos.x, s.body.get(b).pos.y, snake[snekID].newpos[0], snake[snekID].newpos[1]);
        if (distance >= maxdist)     //snek eats snek
          continue;
        snake[snekID].dead = true;
        println("Snake bit snake");
        return;
      }
    }
}

void testSnekOneSnakes() {
   testSnekOneSnakesID(0);
}

void testSnekOneFood() {
  testSnekFoodID(0);
}

void testSnekFoodID(int snekID){
    if (snake[snekID].dead == true)
    return;
  int id = snekID;
  int[] newpos = new int[2];
  newpos[0] = snake[snekID].newpos[0];
  newpos[1] = snake[snekID].newpos[1];
  ArrayList <Integer> gridIDs = new ArrayList <Integer>();
  gridIDs = FindGrid(GridSize, id);
  //searches for the nearest food
  //eats it if its close enough
  for (int g = 0; g< gridIDs.size(); g++) {      //each grid test
    for (int f = 0; f< grid.get(gridIDs.get(g)).food.size(); f++) {      //each food in each grid
      int foodID = grid.get(gridIDs.get(g)).food.get(f);
      float distance = dist(food.get(foodID).pos.x, food.get(foodID).pos.y, newpos[0], newpos[1]);
      if (distance <= snake[0].upgrades.glow) {
        food.get(foodID).countSnake = snake[0].SLength;
      }
      if (distance >= ((food.get(foodID).size+snake[snekID].size)/2) + snake[snekID].upgrades.magnetDist )
        continue;
      for (int k=0; k<food.get(foodID).value; k++)
        snake[snekID].body.add(new SnakeBody(snake[snekID].body.get(snake[snekID].body.size()-3).pos));
      if (food.get(foodID).value == 0) {     //Upgrade to be made
        snake[snekID].upgrades.PreUpdate();
      } else {
        snake[snekID].SLength+=food.get(foodID).value;
        maxFood+=food.get(foodID).value;
      }
      food.get(foodID).reset();
      grid.get(gridIDs.get(g)).food.remove(f);
      fillGridsFood();
      if (snake[snekID].NPC == false) {
      }
      gameSound[0].play();
    }
  }
}
