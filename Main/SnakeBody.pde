class SnakeBody{
  int[] pos = {0,0};

  int size = 10;
  color colour = #00FFFF;
  
  SnakeBody(){
    pos[0] = -20;
    pos[1] = -20;
  }
  SnakeBody(int x, int y){
    pos[0] = x;
    pos[1] = y;
  }
}
