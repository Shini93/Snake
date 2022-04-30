class Special{
  int[] pos = new int[2];    //x,y position
  color colour = 255;          //startcolor is black
  int size = 30;
  int id;
  boolean RayCast = false;
  //TODO: Add special for overall speed, size of the minisnakes
  
  int fade = 0;
  int Specialvalue;          //rocketNr, speed, miniSnakes, rayDist, rayRad, radiation
  Special(int Value, int snakeID){
    pos[0] = snake[snakeID].body.get(snake[snakeID].body.size()-2).pos[0];
    pos[1] = snake[snakeID].body.get(snake[snakeID].body.size()-2).pos[1];   
    Specialvalue = Value;
  }
  
  
}
