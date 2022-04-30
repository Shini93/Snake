class GridSystem{
  int gridX;
  int gridY;
  ArrayList<Integer> food = new ArrayList <Integer>();
  ArrayList<Integer> block = new ArrayList <Integer>();
  
  ArrayList<Integer>[] SnakeBody = new ArrayList[NumberPlayer];

  GridSystem(int count){
    gridX = count%(WorldSizeX/GridSize);
    gridY = floor(count/(WorldSizeX/GridSize));
    for(int i=0;i<NumberPlayer;i++)
      SnakeBody[i] = new ArrayList <Integer>();
  }
}

ArrayList FindGrid(float maxDist, int snakeID){
  int NrGridX = WorldSizeX/GridSize;
  int maxTiles = round(maxDist/GridSize);
  int snekpos = snakeGridPos(snakeID);
  ArrayList <Integer> gridpos = new ArrayList <Integer>();
  fill(255,100);
  for(int y=-maxTiles;y<maxTiles+1;y++){
     for(int x = -maxTiles; x<maxTiles+1;x++){
         if(snakeGridPos(0)+y*NrGridX>=0 && snakeGridPos(0)+x>=0 ){
           if(snekpos+x+y*NrGridX>=0 && snekpos+x+y*NrGridX <MaxGrids){
             gridpos.add(snekpos+x+y*NrGridX);
           }
       }
    }
  }
  return gridpos;
}

void deleteGrids(int what){
  if(what == 0){      //delete all
    for(GridSystem grid : grid){
       grid.block.clear();
       grid.food.clear();
       for(int i=0;i<NumberPlayer;i++)
         grid.SnakeBody[i].clear();
     }
  }else if(what == 1){      //delete food
    for(GridSystem grid : grid){
       grid.food.clear();
     }
  }
  else if(what == 2){      //delete food
    for(GridSystem grid : grid){
       grid.block.clear();
     }
  }
}

 void fillGrids(){
    deleteGrids(0);
    for(int b = 0;b<blocks.size();b++){
      int gridIDY = floor(blocks.get(b).pos[1]/GridSize);
      int gridIDX = floor(blocks.get(b).pos[0]/GridSize);
      int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
      grid.get(GridID).block.add(b);
    }
    for(int f = 0;f<food.size();f++){
      int gridIDY = floor(food.get(f).posy/GridSize);
      int gridIDX = floor(food.get(f).posx/GridSize);
      int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
      if(GridID < 0 || GridID > 207)
        println("Error incoming: x:"+food.get(f).posx+";   y:"+food.get(f).posy+";  GridIDX: "+gridIDX+";  GridIDY:"+gridIDY);
      grid.get(GridID).food.add(f);
    }
    for(int i=0;i<NumberPlayer;i++){
      if(snake[i].body.size()>0){
        for(int s = 0;s<snake[i].body.size();s++){
          int gridIDY = floor(snake[i].body.get(s).pos[1]/GridSize);
          int gridIDX = floor(snake[i].body.get(s).pos[0]/GridSize);
          int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
          grid.get(GridID).SnakeBody[i].add(s);
        }
      }
    }
  }

  void fillGridsBlocks(){
    deleteGrids(2);
    for(int f = 0;f<blocks.size();f++){
      int gridIDY = floor(blocks.get(f).pos[1]/GridSize);
      int gridIDX = floor(blocks.get(f).pos[0]/GridSize);
      int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
      if(GridID < 0 || GridID > 207)
        println("Error incoming: x:"+food.get(f).posx+";   y:"+food.get(f).posy+";  GridIDX: "+gridIDX+";  GridIDY:"+gridIDY);
      grid.get(GridID).block.add(f);
    }
   }
   void fillGridsFood(){
    deleteGrids(1);
    for(int f = 0;f<food.size();f++){
      int gridIDY = floor(food.get(f).posy/GridSize);
      int gridIDX = floor(food.get(f).posx/GridSize);
      int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
      if(GridID < 0 || GridID > 207)
        println("Error incoming: x:"+food.get(f).posx+";   y:"+food.get(f).posy+";  GridIDX: "+gridIDX+";  GridIDY:"+gridIDY);
      grid.get(GridID).food.add(f);
    }
   }
  int snakeGridPos(int snakes){
    int gridIDY = floor(snake[snakes].body.get(0).pos[1]/GridSize);
    int gridIDX = floor(snake[snakes].body.get(0).pos[0]/GridSize);
    int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
    return GridID;
  }
  int GridPos(int x, int y){
    int gridIDY = floor(y/GridSize);
    int gridIDX = floor(x/GridSize);
    int GridID = gridIDX+gridIDY*floor((WorldSizeX/GridSize));
    return GridID;
  }
