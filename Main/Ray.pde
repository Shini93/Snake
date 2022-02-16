class Ray{
  int[][] pos = new int[2][2];    
  float Angle=0;
  boolean obstacle = false;
  color colour = #FFFFFF;
  float maxDist = 999999;
  float dist = 99999;
  int[] savepos = new int[2];
  int saveBlock = 0;
  Byte saveType = 0;    //Blocks, Food, Portal, Special
  
  Ray(int x, int y, float pAngle){
    saveBlock = 0;
    pos[0][0] = x;
    pos[0][1] = y;
    Angle = pAngle;
    pos[1][0] = round(pos[0][0]+sin(Angle)*100);
    pos[1][1] = round(pos[0][1]-cos(Angle)*100);
    checkObstacle();
    drawLine();
  }
  void update(){
    float diffAngle = min((2 * PI) - abs(Angle - snake.Angle), abs(Angle - snake.Angle));
    if(diffAngle < PI/8){            //double degrees, since its -PI/4 to +PI/4
      pos[0][0] = snake.body.get(0).pos[0];
      pos[0][1] = snake.body.get(0).pos[1];
      checkObstacle();
      if(obstacle == true)
        drawLine();
      else{
        stroke(#FFFFFF, 150);
        line(pos[0][0],pos[0][1],round(pos[0][0]+sin(Angle)*800),round(pos[0][1]-cos(Angle)*800));
      }
    }
  }
  void checkObstacle(){
    maxDist = 99999;
    checkBlocks();
    checkFood();
  }
  
  void checkFood(){
    int x1,y1,x2,y2,x3,x4,y3,y4=0;
    float den,t,u=0;
    for(int i=0;i<food.size();i++){
      float Angle2;
      float dist2 = dist(snake.body.get(0).pos[0],snake.body.get(0).pos[1],food.get(i).posx,food.get(i).posy);
      if(snake.body.get(0).pos[0]<food.get(i).posx)
        Angle2 = acos((food.get(i).posy-snake.body.get(0).pos[1])/dist2);
      else
        Angle2 = acos((-food.get(i).posy+snake.body.get(0).pos[1])/dist2);
      x1 = int(food.get(i).posx-cos(Angle2)*food.get(i).normalSize/2);
      y1 = int(food.get(i).posy+sin(Angle2)*food.get(i).normalSize/2);
      x2 = int(food.get(i).posx+cos(Angle2)*food.get(i).normalSize/2);
      y2 = int(food.get(i).posy-sin(Angle2)*food.get(i).normalSize/2);

      dist = int(sqrt((pos[0][0]-x1)*(pos[0][0]-x1)+(pos[0][1]-y1)*(pos[0][1]-y1)));
      
      if(dist < maxDist){
        pos[1][0] = round(pos[0][0]+sin(Angle)*dist);
        pos[1][1] = round(pos[0][1]-cos(Angle)*dist);
        x3=pos[0][0];
        y3 = pos[0][1];
        x4 = pos[1][0];
        y4 = pos[1][1];
        den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
        if(den !=0){
          t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den;
          u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;    
          if(t>0 && t<1 && u>0){
            obstacle = true;
            maxDist = dist;
            savepos[0] = pos[1][0];
            savepos[1] = pos[1][1];
            saveBlock = i;
            saveType = 1;
          }
        }
      }
    }
  }
  
  
  void checkBlocks(){
    int x1,y1,x2,y2,x3,x4,y3,y4=0;
    float den,t,u=0;
    for(int i=0;i<blocks.size();i++){
      for(int k=0;k<4;k++){
        if(k==0){                        //top
          x1 = blocks.get(i).pos[0];
          y1 = blocks.get(i).pos[1];
          x2 = blocks.get(i).pos[0]+blocks.get(i).size;
          y2 = blocks.get(i).pos[1];
        }
        else if(k==1){
          x1 = blocks.get(i).pos[0];
          y1 = blocks.get(i).pos[1];
          x2 = blocks.get(i).pos[0];
          y2 = blocks.get(i).pos[1]+blocks.get(i).size;

        }
        else if(k==2){
          x1 = blocks.get(i).pos[0];
          y1 = blocks.get(i).pos[1]+blocks.get(i).size;
          x2 = blocks.get(i).pos[0]+blocks.get(i).size;
          y2 = blocks.get(i).pos[1]+blocks.get(i).size;

        }
        else {
          x1 = blocks.get(i).pos[0]+blocks.get(i).size;
          y1 = blocks.get(i).pos[1];
          x2 = blocks.get(i).pos[0]+blocks.get(i).size;
          y2 = blocks.get(i).pos[1]+blocks.get(i).size;

        }
        x3 = pos[0][0];
        y3 = pos[0][1];
        x4 = pos[1][0];
        y4 = pos[1][1];  
        dist = sqrt((pos[0][0]-min(x1,x2))*(pos[0][0]-min(x1,x2))+(pos[0][1]-min(y1,y2))*(pos[0][1]-min(y1,y2)));
        
        if(dist < maxDist){
          pos[1][0] = int(pos[0][0]+sin(Angle)*dist);
          pos[1][1] = int(pos[0][1]-cos(Angle)*dist);
          den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
          if(den !=0){
            t = ((x1-x3)*(y3-y4)-(y1-y3)*(x3-x4))/den;
            u = -((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;    
            if(t>0 && t<1 && u>0){
              obstacle = true;
              maxDist = dist;
              savepos[0] = int(x1+t*(x2-x1));  //pos[1][0];
              savepos[1] = int(y1+t*(y2-y1));  //pos[1][1];
              saveBlock = i;
              saveType = 0;
            }
          }
        }
      }
    }
  }
  
  void drawLine(){
    if(saveType == 0){
      blocks.get(saveBlock).RayCast = true;
      blocks.get(saveBlock).fade = 255;
    }
    else if(saveType == 1){
      //food.get(saveBlock).colour = #FFFFFF;
      food.get(saveBlock).init();
      stroke(#5555FF, 150);
      
    }
    line(pos[0][0],pos[0][1],savepos[0],savepos[1]);
    obstacle = false;
  }
}
