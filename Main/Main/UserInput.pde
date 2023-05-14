/********************
 *handles Mouseevents
 *Starts Missles
 ********************/
void mousePressed() {
  if (GameStart== false)        //no snake input outside the game
    return;
  println("pressed");
  changeSnakeSpeed(snake[0].upgrades.SpeedValue);
  applyMissile();

  if (isAndroid == true) {
    mousepos = new PVector(mouseX, mouseY);
  }
}

void mouseReleased() {
  if(GameStart == false)
    return;
  changeSnakeSpeed(-snake[0].upgrades.SpeedValue);
}


void keyPressed() {
  if (key == ESC && GameStart == true) {
    snake[0].dead = true;
    datahandler.savetoJson();
    GameStart = false;
    shopmenu = false;
    lvls.reset();
    background(BackgroundColor);
    key = 0;
    initButtonsStartScreen();
    guiPages[1].active = false;
  } else if (key == ESC)
    exit();
  else if (key == 'p' || key == 'P')
    gamePause = !gamePause;
  else if (NumberPlayer == 1)
    return;
  if (key == 'A' || key == 'a')
    directionKey = -1;
  else if (key == 'D' || key == 'd')
    directionKey = 1;
  else if (key == 'm' || key == 'M') {
    if (snake[1].upgrades.speed == true)
      snake[1].speedSnake *= 2;
  }
}

void keyReleased() {
  directionKey = 0;
  if (NumberPlayer >1 && snake[1] != null)
    snake[1].speedSnake /= 2;
}

void changeSnakeSpeed(float value) {
  if (mouseButton == LEFT && snake[0].upgrades.speed == true && isAndroid == false) {
    snake[0].speedSnake += value;        //TODO: Change to dynamic value
  }
}

//void touchStarted(){
//   if(isAndroid == false)
//     return;
//   if(androidSpeed.isFired() == true){
//      snake[1].speedSnake *= 2;
//   }
//}

//void touchEnded(){
//  if(isAndroid == false)
//     return;
//   if(GameStart == true && androidSpeed.isMouseOver()){
//      snake[1].speedSnake *= 2;
//   }
//}


//Starts missile when right mouse is clicked and missiles activated
void applyMissile() {
  if (mouseButton != RIGHT )
    return;
  if (snake[0].upgrades.missile != true)
    return;

  snake[0].missilealive = true;
  float dAngle;      //Angle difference between the snake head and the block with the nearest Angle
  float Angle;
  float min=2*PI;    //minumum Angle between Snake and block
  int id=0;

  //Find Block to attack
  for (int i=0; i<blocks.size()-1; i++) {
    Angle = math.Anglecalc(snake[0].body.get(0).pos.x, snake[0].body.get(0).pos.y, blocks.get(i).pos.x+blocks.get(i).size/2, blocks.get(i).pos.y+blocks.get(i).size/2);
    dAngle = abs(Angle - snake[0].Angle);
    if (dAngle<min) {
      min = dAngle;
      id = blocks.get(i).id-1;
    }
  }

  //Create new missile with block target
  snake[0].missile = new Missiles(id, snake[0].body.get(0).pos);    //adds missile starting from the snake
}

void backPressed() {
  fill(125);
  rect(0, 0, dWidth, dHeight);
  //background(125);
  snake[0].dead = true;
  datahandler.savetoJson();
  GameStart = false;

  shopmenu = false;

  lvls.reset();
  initButtonsStartScreen();
}
