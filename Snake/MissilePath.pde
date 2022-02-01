/**************************************
*Handles the Missile Path
*one pos per element
**************************************/
class MissilePath {
  byte size = 10;
  int [] pos = new int [2];
  int fade = 255;
  byte id;
  byte alive = 10;
  
  MissilePath(int x, int y) {
    pos[0] = x;
    pos[1] = y;
    fade = 255;
  }
  MissilePath() {
    pos[0] = -1;
    pos[1] = -1;
    fade = 255;
  }
  void update() {
    size ++;
    if (fade>=50)
      fade -=20;
    alive--;
  }

  void reset() {
    pos[0] = -1;
    pos[1] = -1;
    fade = 0;
    size=0;
  }
}
