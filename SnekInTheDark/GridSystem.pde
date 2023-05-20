//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- //<>//
void setupGrid() {
  //log.append("grudSysten.setupGrid");
  grid.clear();
  MaxGrids = ceil(worldSize.x*(worldSize.y)/(GridSize*GridSize))+20;    //Sets the maximum grid size
  for (int g = 0; g<MaxGrids; g++) {      //init grids
    grid.add(new GridSystem(g));
  }
  fillGrids();   //fills grids with blocks, food and snakebodyparts
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
class GridSystem {
  int gridX;
  int gridY;
  ArrayList<Integer> food = new ArrayList <Integer>();
  ArrayList<Integer> block = new ArrayList <Integer>();

  ArrayList<Integer>[] SnakeBody = new ArrayList[NumberPlayer];

  //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  GridSystem(int count) {
    gridX = round(count%(worldSize.x/GridSize));
    gridY = floor(count/(worldSize.x/GridSize));
    for (int i=0; i<NumberPlayer; i++)
      SnakeBody[i] = new ArrayList <Integer>();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
ArrayList FindGrid(float maxDist, int snakeID) {
  //log.append("grudSysten.FindGrid");
  int NrGridX = ceil(worldSize.x/GridSize);
  int maxTiles = round(maxDist/GridSize);
  int snekpos = snakeGridPos(snakeID);
  ArrayList <Integer> gridpos = new ArrayList <Integer>();
  fill(255, 100);
  for (int y=-maxTiles; y<maxTiles+1; y++) {
    for (int x = -maxTiles; x<maxTiles+1; x++) {
      if (snakeGridPos(0)+y*NrGridX>=0 && snakeGridPos(0)+x>=0 ) {
        if (snekpos+x+y*NrGridX>=0 && snekpos+x+y*NrGridX <MaxGrids) {
          gridpos.add(snekpos+x+y*NrGridX);
        }
      }
    }
  }
  return gridpos;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void deleteGrids(int what) {
  //log.append("grudSysten.deleteGrids");
  if (what == 0) {      //delete all
    for (GridSystem grid : grid) {
      grid.block.clear();
      grid.food.clear();
      for (int i=0; i<NumberPlayer; i++)
        grid.SnakeBody[i].clear();
    }
  } else if (what == 1) {      //delete food
    for (GridSystem grid : grid) {
      grid.food.clear();
    }
  } else if (what == 2) {      //delete food
    for (GridSystem grid : grid) {
      grid.block.clear();
    }
  } else if (what == 3) {      //delete food
    for (GridSystem grid : grid) {
      for (int i=0; i<NumberPlayer; i++)
        grid.SnakeBody[i].clear();
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void fillGrids() {
  //log.append("grudSysten.fillGrids");
  fillGridsBlocks();
  fillGridsFood();
  fillGridsSnake();
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void fillGridsBlocks() {
  //log.append("grudSysten.fillGridsBlocks");
  deleteGrids(2);
  for (int f = 0; f<blocks.size(); f++) {
    int gridIDY = floor(blocks.get(f).pos.y/GridSize);
    int gridIDX = floor(blocks.get(f).pos.x/GridSize);
    int GridID = gridIDX+gridIDY*floor((worldSize.x/GridSize));
    if (GridID < 0 || GridID > 207)
      println("Error incoming: x:"+food.get(f).pos.x+";   y:"+food.get(f).pos.y+";  GridIDX: "+gridIDX+";  GridIDY:"+gridIDY); //<>// //<>// //<>// //<>//
    if (GridID < grid.size())
      grid.get(GridID).block.add(f);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void fillGridsSnake() {
  //log.append("grudSysten.fillGridsSnake");
  deleteGrids(3);
  for (int i=0; i<NumberPlayer; i++) {
    if (snake[i].body.size()>0) {
      for (int s = 0; s<snake[i].body.size(); s++) {
        int gridIDY = floor(snake[i].body.get(s).pos.y/GridSize);
        int gridIDX = floor(snake[i].body.get(s).pos.x/GridSize);
        int GridID = gridIDX+gridIDY*floor((worldSize.x/GridSize));
        grid.get(GridID).SnakeBody[i].add(s);
      }
    }
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void fillGridsFood() {
  //log.append("grudSysten.fillGridsFood");
  deleteGrids(1);
  for (int f = 0; f<food.size(); f++) {
    int gridIDY = floor(food.get(f).pos.y/GridSize);
    int gridIDX = floor(food.get(f).pos.x/GridSize);
    int GridID = gridIDX+gridIDY*floor((worldSize.x/GridSize));
    if (GridID < 0 || GridID > 207)
      println("Error incoming: x:"+food.get(f).pos.x+";   y:"+food.get(f).pos.y+";  GridIDX: "+gridIDX+";  GridIDY:"+gridIDY);
    grid.get(GridID).food.add(f);
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
int snakeGridPos(int snakes) {
  //log.append("grudSysten.snakeGridPos");
  if (snake[snakes].gridLastFrame <= 0) {
    int gridIDY = floor(snake[snakes].body.get(0).pos.y/GridSize);
    int gridIDX = floor(snake[snakes].body.get(0).pos.x/GridSize);
    int GridID = gridIDX+gridIDY*floor((worldSize.x/GridSize));
    snake[snakes].gridLastFrame = 3;
    snake[snakes].lastGrid = GridID;
    return GridID;
  }
  return snake[snakes].lastGrid;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
int GridPos(int x, int y) {
  //log.append("grudSysten.GridPos");
  int gridIDY = floor(y/GridSize);
  int gridIDX = floor(x/GridSize);
  int GridID = gridIDX+gridIDY*floor((worldSize.x/GridSize));
  return GridID;
}
