class Blocks{
  int[] pos = new int[2];
  color colour = #FFFFFF;
  int size = 30;
  int id;
  
  Blocks(int ida, int x, int y){
    pos[0] = int(random(width));
    pos[1] = int(random(height));
    id = ida;
  }
  
  void reset() {
    pos[0] = int(random(width));
    pos[1] = int(random(height));
  }
}
