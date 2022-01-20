class Blocks{
  float[] pos = new float[2];
  color colour = #FFFFFF;
  int size = 30;
  int id;
  
  Blocks(int ida){
    pos[0] = random(width);
    pos[1] = random(height);
    id = ida;
  }
  
  void reset() {
    pos[0] = random(width);
    pos[1] = random(height);
  }
}
