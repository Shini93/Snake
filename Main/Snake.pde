/******************************************
 *Handles all about Snakes
 ******************************************/
class Snake extends PrimalSnake{
  boolean missilealive = false;   //No Kaboom anymore
  Missiles missile;               //Kaboom!
  Ray[] ray = new Ray[maxRays];
  /***************************************
   *Constructor
   ***************************************/
  Snake(boolean dummy) {
    NPC = dummy;
    print("\ntssssss isssss new ssssssnake\n");
    for(int i=0;i<=SLength;i++){
       body.add(new SnakeBody()); 
    }
  }
  Snake(boolean dummy, int x, int y) {
    NPC = dummy;
    print("\ntssssss isssss new ssssssnake\n");
    for(int i=0;i<=SLength;i++){
       body.add(new SnakeBody()); 
    }
    body.get(0).pos[0] = x;
    body.get(0).pos[1] = y;
  }

  
  

  void initRays(){
    for (int i=0; i<maxRays; i++) {
      ray[i] = new Ray(body.get(0).pos[0], body.get(0).pos[1], i*PI/360);
    } 
  }

  /***************************************
   *Tests if the Path is free
   ***************************************/
   @Override
  void testPath() {
    testFood();
    testSnake();
    testBlocks();    
    if(lvl.setPortal)
      testPortal();  
    testWalls();
  }


  
  void testSnake(){
   //testSnake
    for(Snake s : snake){
      for(int i=0;i<s.SLength;i++){
        float distance = 999;
        distance = sqrt((s.body.get(i).pos[0]-newpos[0])*(s.body.get(i).pos[0]-newpos[0])+(s.body.get(i).pos[1]-newpos[1])*(s.body.get(i).pos[1]-newpos[1]));
        if (distance < size/2) {
          print(SLength + "    " + startLength + "\n");
          dead = true;
          return;
        }
      } 
    }
  }
  
  void testBlocks(){
   //testBlocks
    for(int i=0;i<lvl.blocksize/2-1;i++){
        if(newpos[0]+size/2>=blocks.get(i).pos[0] && newpos[0]-size/2 <= blocks.get(i).pos[0] + blocks.get(i).size && newpos[1]+size/2>=blocks.get(i).pos[1] && newpos[1] -size/2 <= blocks.get(i).pos[1] + blocks.get(i).size){
          dead = true;
          println("AU!");
          return;
      }
    } 
  }
  
  
  void testPortal(){
  //testPortal
    if(portaltime > 20){
      for(byte k=0;k<MaxPortals;k++){
        float[] distance = new float[2];
        boolean teleported = false;
        for(int i=0;i<2;i++){
          if(teleported==false){
            distance[i] = abs(distance(portal[k].pos[i][0], portal[k].pos[i][1],newpos[0],newpos[1]));
            if (distance[i] < (size+portal[k].size*sqrt(2))/2 ) {
              if(newpos[0]+size/2 > portal[k].pos[i][0]-portal[k].size/4 && newpos[0]-size/2 <= portal[k].pos[i][0]+portal[k].size/4 && newpos[1]+size/2 > portal[k].pos[i][1]-portal[k].size/2 && newpos[1]-size/2 <= portal[k].pos[i][1]+portal[k].size/2){
                teleport(portal[k].pos[1-i][0],portal[k].pos[1-i][1]);
                portaltime = 0;
                teleported = true;
              }
            }
          }
        }
      }
    }
    if(portaltime <=20)
      portaltime ++;
  }
}
