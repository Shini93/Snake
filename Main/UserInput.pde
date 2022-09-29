/********************
 *handles Mouseevents
 *Starts Missles
 ********************/
void mousePressed() {
  if(GameStart== false)
    return;
  if(mouseButton == LEFT && snake[0].upgrades.speed == true){
    snake[0].speedSnake *= 2;
  }
  if(mouseButton == RIGHT && snake[0].upgrades.missile == true){
    snake[0].missilealive = true;
    float dAngle;      //Angle difference between the snake head and the block with the nearest Angle
    float Angle;
    float min=2*PI;    //minumum Angle between Snake and block
    int id=0;
    for (int i=0; i<blocks.size()-1; i++) {
      Angle = math.Anglecalc(snake[0].body.get(0).pos[0], snake[0].body.get(0).pos[1], blocks.get(i).pos[0]+blocks.get(i).size/2, blocks.get(i).pos[1]+blocks.get(i).size/2);
      dAngle = abs(Angle - snake[0].Angle);
      if (dAngle<min) {
        min = dAngle;
        id = blocks.get(i).id-1;
      }
    }
    snake[0].missile = new Missiles(id, snake[0].body.get(0).pos[0], snake[0].body.get(0).pos[1]);    //adds missile starting from the snake
  }
  
  if(isAndroid == true){
    mousepos[0] = mouseX;
    mousepos[1] = mouseY;
  }
}

void mouseReleased(){
  if(GameStart == true && mouseButton == LEFT)
    snake[0].speedSnake /= 2; 
}


void keyPressed(){
   if(key == ESC && GameStart == true){
     snake[0].dead = true;
     datahandler.savetoJson();
     GameStart = false;
     deactivateButton[0] = false;
     shopmenu = false;
     background(125);
     key = 0;
     initButtons();
   }
   else if(key == ESC)
     exit();
   else if(NumberPlayer == 1)
     return;
   if(key == 'A' || key == 'a')
     directionKey = -1;
   else if(key == 'D' || key == 'd')
     directionKey = 1;
   else if(key == 'm' || key == 'M'){
     if(snake[1].upgrades.speed == true)
       snake[1].speedSnake *= 2;
  }
}

void keyReleased(){
   directionKey = 0; 
   if(NumberPlayer >1 && snake[1] != null)
     snake[1].speedSnake /= 2;
}
