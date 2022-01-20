class Missiles {
  int velocity = 1;
  float[] pos = new float[2];
  int target = 0;    //target ID
  float Angle = 0;
  int count=1;
  int alive = 0;

  Missiles(int Target, float Posx, float Posy) {
    target = Target;
    pos[0] = Posx;
    pos[1] = Posy;
    alive = 0;
  }
  Missiles() {
  }

  void reset() {
    missilealive = false;
    velocity = 0;
    for (int i=0; i<10; i++) {
      pos[0] = 0;
      pos[1] = 0;
    }
  }

  void move() {
    for (int i=0; i<10; i++) {
      if (blocks[i].id == target) {
        Angle = Anglecalc(pos[0],pos[1],blocks[i].pos[0], blocks[i].pos[1]);
        pos[0] = cos(Angle)*velocity+pos[0];
        pos[1] = -sin(Angle)*velocity+pos[1];

        float distance = sqrt((pos[0]-blocks[i].pos[0])*(pos[0]-blocks[i].pos[0])+(pos[1]-blocks[i].pos[1])*(pos[1]-blocks[i].pos[1]));
        if (distance <=velocity) {
          blocks[i].reset();
          reset();
        }
        break;
      }
    }
    velocity++;
    alive ++;
  }
}
