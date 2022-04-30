class Missiles {
  int velocity = 1;
  int[] pos = new int[2];
  int target = 0;    //target ID
  float Angle = 0;
  int count=1;
  int alive = 0;

  Missiles(int Target, int Posx,int Posy) {
    target = Target;
    pos[0] = Posx;
    pos[1] = Posy;
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
    Angle = math.Anglecalc(pos[0],pos[1],blocks.get(target).pos[0], blocks.get(target).pos[1]);
    pos[0] = int(-math.cosAlike(Angle)*velocity+pos[0]);
    pos[1] = int(-math.cosAlike(Angle-PI/2)*velocity+pos[1]);

    float distance = sqrt((pos[0]-blocks.get(target).pos[0])*(pos[0]-blocks.get(target).pos[0])+(pos[1]-blocks.get(target).pos[1])*(pos[1]-blocks.get(target).pos[1]));
    if (distance <=velocity) {
      blocks.get(target).reset();
      reset();
    }
    velocity++;
    alive ++;
  }
}
