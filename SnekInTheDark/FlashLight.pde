/***************************** //<>// //<>// //<>// //<>// //<>//
 *Lets the player see
 *finds all entities to be seen
 *draws seeable on screen
 *****************************/
class FlashLight {
  int playerID = 0;
  float sizeFlash;
  float dWidthFlash;
  float angleSnake;
  PVector pos;

  FlashLight(int pID) {
    playerID = pID;
  }

  void update() {
    //log.append("flash.update");
    sizeFlash = snake[playerID].upgrades.RayDistance;
    dWidthFlash = snake[playerID].upgrades.RayRadius;
    angleSnake = snake[playerID].Angle;

    int x = int(snake[playerID].body.get(0).pos.x);
    int y = int(snake[playerID].body.get(0).pos.y);
    pos =   snake[playerID].body.get(0).pos;
    //findBlocks(x, y);
    //findFood(x, y);
    drawLight(x, y);
  }

  //Draws light on the screen
  void drawLight(float x, float y) {
    if (debugView == true)
      return;
    //log.append("flash.drawLight");
    for (int i = 1; i < 4; i ++) {
      SnakeGraphic.fill(#FFFFFF, 20);
      SnakeGraphic.noStroke();
      SnakeGraphic.beginShape();
      SnakeGraphic.vertex(x, y);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake-dWidthFlash))/i, y-(sizeFlash*sin(angleSnake-dWidthFlash))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake))/i, y-(sizeFlash*sin(angleSnake))/i);
      SnakeGraphic.vertex(x-(sizeFlash*cos(angleSnake+dWidthFlash))/i, y-(sizeFlash*sin(angleSnake+dWidthFlash))/i);
      SnakeGraphic.endShape(CLOSE);
    }
  }

  Boolean findBlock(PVector block, float distance, int bID) {
    //log.append("flash.findBlock");
    if (distance > sizeFlash)
      return false;
    if (blocks.get(bID).fade == 255)
      return false;
    float angleBlock = math.Anglecalc(pos.x, pos.y, block.x+30*0.5, 0.5*30+block.y);
    float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
    if (abs(diffAngle) > dWidthFlash)
      return false;
    blocks.get(bID).RayCast = true;
    blocks.get(bID).fade = 255;
    return true;
  }

  Boolean findFood(PVector f, float distance, int fID) {
    //log.append("flash.findFood");
    if (distance > sizeFlash)
      return false;
    //if (food.get(fID).fade == 255) {
    //  food.get(fID).init();
    //  food.get(fID).fade = 255;
    //  return false;
    //}
    float angleBlock = math.Anglecalc(pos.x, pos.y, f.x+30*0.5, 0.5*30+f.y);
    float diffAngle = min((2 * PI) - abs(angleBlock - angleSnake), abs(angleBlock - angleSnake));
    if (abs(diffAngle) > dWidthFlash)
      return false;
    food.get(fID).init();
    food.get(fID).fade = 255;
    return true;
  }

  void findBlocks(float x, float y) {
    //log.append("flash.findBlocks");
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
    //log.append("flash.findFood");
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

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//Lightning strike
//sets fade = 255 for all
class Lightning {
  boolean isActive = true;
  int interval;
  int timer;
  PImage[] lightningImg;
  int imgToPlay = 0;
  PVector pos;

  Lightning() {
    interval = 30 * 30;
    timer = 30 * 30;
    lightningImg = picToFrames("img/Thunderstrike.png", 12);
  }
  Lightning(int interval) {
    this.interval = 30 * interval;  //in seconds
    this.timer =  30 * interval;
    lightningImg = picToFrames("img/Thunderstrike.png", 12);
  }

  void update() {
    if(isActive == false)
      return;
    timer --;
    offsetMult = new PVector(0,0);
    if (timer > 0 && imgToPlay == 0)
      return;
    if(timer == 0){
      gameSound[2].play();
      pos = new PVector(random(dWidth),random(dHeight)); 
    }
    timer = round(random(0.6 + interval,interval + 3));
    drawLightning();
    lightenEntities();
  }
  
  void drawLightning(){
    SnakeGraphic.image(lightningImg[imgToPlay],pos.x,pos.y);
    println(imgToPlay);
    int whitness = 125 / (imgToPlay + 1);
    BackgroundColor = color(whitness);
    imgToPlay = (imgToPlay + 1 ) % 12;
    offsetMult = new PVector( 3 * (30 - imgToPlay) * noise( 0.1 * millis()), 3 * (30 - imgToPlay) * noise( 0.1 * millis() + 100));
  }
}
