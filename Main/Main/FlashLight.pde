/***************************** //<>//
 *Lets the player see
 *finds all entities to be seen
 *draws seeable on screen
 *****************************/
class FlashLight {
  int playerID = 0;
  float sizeFlash;
  float dWidthFlash;
  float angleSnake;

  FlashLight(int pID) {
    playerID = pID;
  }

  void update() {
    sizeFlash = snake[playerID].upgrades.RayDistance;
    dWidthFlash = snake[playerID].upgrades.RayRadius;
    angleSnake = snake[playerID].Angle;

    int x = int(snake[playerID].body.get(0).pos.x);
    int y = int(snake[playerID].body.get(0).pos.y);

    findBlocks(x, y);
    findFood(x, y);
    drawLight(x, y);
  }

  //Draws light on the screen
  void drawLight(float x, float y) {
    for (int i = 1; i < 4; i ++) {
      SnakeGraphic.fill(#FFFFFF, 40);
      SnakeGraphic.noStroke();
      SnakeGraphic.beginShape();
      SnakeGraphic.vertex(x, y);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake-dWidthFlash))/i, y-(sizeFlash*sin(angleSnake-dWidthFlash))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake))/i, y-(sizeFlash*sin(angleSnake))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake+dWidthFlash))/i, y-(sizeFlash*sin(angleSnake+dWidthFlash))/i);
      SnakeGraphic.endShape(CLOSE);
    }
  }

  void findBlocks(float x, float y) {
    for (Blocks b : blocks) {
      float d = dist(b.pos.x+0.5*b.size, b.pos.y+0.5*b.size, x, y);
      if (d > sizeFlash)
        continue;
      float angleBlock = math.Anglecalc(x, y, b.pos.x+b.size*0.5, 0.5*b.size+b.pos.y);
      float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
      if (abs(diffAngle) > dWidthFlash)
        continue;
      b.RayCast = true;
      b.fade = 255;
    }
  }

  void findFood(int x, int y) {
    for (Food f : food) {
      float d = dist(f.pos.x+0.5*f.size, f.pos.y+0.5*f.size, x, y);
      if (d > sizeFlash)
        continue;
      float angleBlock = math.Anglecalc(x, y, f.pos.x+f.size*0.5, 0.5*f.size+f.pos.y);
      float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
      if (abs(diffAngle) > dWidthFlash)
        continue;
      f.init();
      f.fade = 255;
    }
  }
}
