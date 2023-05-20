class Missiles {
  int velocity = 1;
  int[] pos = new int[2];
  int target = 0;    //target ID
  float Angle = 0;
  int count=1;
  int alive = 0;

  Missiles(int Target, PVector Pos) {
    target = Target;
    pos[0] = round(Pos.x);
    pos[1] = round(Pos.y);
    alive = 0;
  }
  Missiles() {
  }

  void reset() {
    snake[0].missilealive = false;
    velocity = 0;
    for (int i=0; i<10; i++) {
      pos[0] = 0;
      pos[1] = 0;
    }
  }

  void move() {
    //log.append("missile.move");
    Angle = math.Anglecalc(pos[0],pos[1],blocks.get(target).pos.x, blocks.get(target).pos.y);
    pos[0] = int(-math.cosAlike(Angle)*velocity+pos[0]);
    pos[1] = int(-math.cosAlike(Angle-PI/2)*velocity+pos[1]);

    float distance = sqrt((pos[0]-blocks.get(target).pos.x)*(pos[0]-blocks.get(target).pos.x)+(pos[1]-blocks.get(target).pos.y)*(pos[1]-blocks.get(target).pos.y));
    if (distance <=velocity) {
      blocks.get(target).reset();
      reset();
    }
    velocity++;
    alive ++;
  }
}

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
    //log.append("missilePath.update");
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
