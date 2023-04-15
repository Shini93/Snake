/***************************** //<>//
 *Lets the player see
 *finds all entities to be seen
 *draws seeable on screen
 *****************************/
class FlashLight {
  int playerID = 0;
  float sizeFlash;
  float widthFlash;
  float angleSnake;

  FlashLight(int pID) {
    playerID = pID;
  }

  void update() {
    sizeFlash = snake[playerID].upgrades.RayDistance;
    widthFlash = snake[playerID].upgrades.RayRadius;
    angleSnake = snake[playerID].Angle;

    int x = snake[playerID].body.get(0).pos[0];
    int y = snake[playerID].body.get(0).pos[1];

    findBlocks(x, y);
    findFood(x, y);
    drawLight(x, y);
  }

  //Draws light on the screen
  void drawLight(int x, int y) {
    for (int i = 1; i < 4; i ++) {
      SnakeGraphic.fill(#FFFFFF, 40);
      SnakeGraphic.noStroke();
      SnakeGraphic.beginShape();
      SnakeGraphic.vertex(x, y);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake-widthFlash))/i, y-(sizeFlash*sin(angleSnake-widthFlash))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake))/i, y-(sizeFlash*sin(angleSnake))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake+widthFlash))/i, y-(sizeFlash*sin(angleSnake+widthFlash))/i);
      SnakeGraphic.endShape(CLOSE);
    }
  }

  void findBlocks(int x, int y) {
    for (Blocks b : blocks) {
      float d = dist(b.pos[0]+0.5*b.size, b.pos[1]+0.5*b.size, x, y);
      if (d <= sizeFlash) {
        float angleBlock = math.Anglecalc(x, y, b.pos[0]+b.size*0.5, 0.5*b.size+b.pos[1]);
        float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
        if (abs(diffAngle) <= widthFlash) {
          b.RayCast = true;
          b.fade = 255;
        }
      }
    }
  }

  void findFood(int x, int y) {
    for (Food f : food) {
      float d = dist(f.posx+0.5*f.size, f.posy+0.5*f.size, x, y);
      if (d <= sizeFlash) {
        float angleBlock = math.Anglecalc(x, y, f.posx+f.size*0.5, 0.5*f.size+f.posy);
        float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
        if (abs(diffAngle) <= widthFlash) {
          f.init();
        }
      }
    }
  }
}
