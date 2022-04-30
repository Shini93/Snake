class miniSnake extends PrimalSnake{
  int distanceSnake = 30;
  float AngleSnake = 0;
  float distancesindelta = 5;
  float distanceAngledelta = 0;
  int snakeID;
  miniSnake(int side, int snakeNumber){
    snakeID = snakeNumber;
    SLength = 10;
    for(int i=0;i<=SLength;i++){
     body.add(new SnakeBody()); 
    }
    if(side == 1)
      AngleSnake = PI/2;
    else
      AngleSnake = -PI/2; 
  }
  
  
  @Override
  void nextTile() {
    body.get(0).pos[0] = snake[snakeID].body.get(0).pos[0]      //snakeHead Main
      -int((distancesindelta                                    //distance to snakeHead Main
          *math.sinS(distanceAngledelta)+distanceSnake)                //frequency
          *math.cosAlike(snake[snakeID].Angle+AngleSnake));                //which side snaky is at
    body.get(0).pos[1] = snake[snakeID].body.get(0).pos[1]-int((distancesindelta*math.sinS(distanceAngledelta)+distanceSnake)*math.sinS(snake[snakeID].Angle+AngleSnake));
    distanceAngledelta+=80*PI/360;
  }
  
  
  @Override
  void Calcsize(){
   size=5; 
  }
  
  @Override
  void testFood(){
   //TestFood
   newpos[0] = body.get(0).pos[0];
   newpos[1] = body.get(0).pos[1]; //<>//

      float distance = sqrt((snake[snakeID].nearestFood.posx-newpos[0])*(snake[snakeID].nearestFood.posx-newpos[0])+(snake[snakeID].nearestFood.posy-newpos[1])*(snake[snakeID].nearestFood.posy-newpos[1]));
      if (distance < (snake[snakeID].nearestFood.size+size)/2) { //<>//
        body.add(new SnakeBody(15,15));
        SLength ++;
        for(int k=0;k<snake[snakeID].nearestFood.value;k++){
          snake[snakeID].body.add(new SnakeBody(15,15));
        }
        if(snake[snakeID].nearestFood.value == 0){     //Upgrade to be made
          snake[snakeID].upgrades.PreUpdate();
        }else{
          snake[snakeID].SLength+=snake[snakeID].nearestFood.value;
          maxFood+=snake[snakeID].nearestFood.value;
        }
        snake[snakeID].nearestFood.reset();
        fillGridsFood();
      }
  }
}
