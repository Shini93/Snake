void mousePressed() {
  Mousepressed = !Mousepressed;
  if(Mode == "Snake"){
     snake[0] = mouseX;
     snake[1] = mouseY;
  }
  else if(Mode == "movingBlockLine"){
    int xscaled = 0;
    int yscaled = 0;
    xscaled = round(((ImouseX+scale/2)/scale))*scale;
    yscaled = round(((ImouseY+scale/2)/scale))*scale;
     BlockLine[maxMovingLine][0] = xscaled;
     BlockLine[maxMovingLine][1] = yscaled;
     maxMovingLine++;
  }
}

void mouseReleased() {
  Mousepressed = !Mousepressed;
}

void keyPressed() {
  if (key =='p' || key == 'P') {             //print current blocks to console.
    print("\nx:\n"+blocksx);
    print("\ny:\n"+blocksy);
  } else if (key =='z' || key == 'Z') {      //Undo last move
    if(Mode=="Blocks" && blocksx.size()>0){
      blocksx.remove(blocksx.size()-1);
      blocksy.remove(blocksy.size()-1);
    }
    else if(Mode=="Food"){
      if(maxFood>0)
        maxFood--;
    }
    else if(Mode=="movingBlockLine"){
      BlockLine[maxMovingLine][0] = 0;
      BlockLine[maxMovingLine][1] = 0;
      if(maxMovingLine>0)
        maxMovingLine--;
    }
    else if(Mode=="Portals"){
      if(maxPortal>0)
        maxPortal--;
    }
  } else if (key =='r' || key == 'R') {      //reverse Blocks
    if(Mode=="Blocks"){
      ReverseBlocks();
    }
    else if(Mode=="Food"){
       ReverseFood();
    }
  } else if (key =='S' || key == 's') {      //saves to file
    filehandler.savetoFile();
    createImage();
    resetAll();
   // setup();
  }  
  else if(key == 'm' || key == 'M')
    MirrorOn = !MirrorOn;
  else if(key == '+'){
    scaleFact += 0.05;
    //scale += 5;
    World.x = round(width/scaleFact); 
    World.y = round(height/scaleFact); 

   // noLines = createGraphics(round(World.x), round(World.y));
  }
  else if(key == '-'){
    scaleFact -= 0.05;
    //scale -= 5;
    World.y = round(height/scaleFact); 
    World.x = round(width/scaleFact); 
   // noLines = createGraphics(round(World.x), round(World.y));
  }
  else if (key ==TAB) {      //saves to file
    switchKey++;            //0:Blocks, 1:Snake, 2: Food, 3: Portals
    if(switchKey ==0)
      Mode = "Blocks";
    else if(switchKey ==1)
      Mode = "Snake";
    else if(switchKey ==2)
      Mode = "Food";
    else if(switchKey == 3)
      Mode = "Portals";
    else if(switchKey == 4){
      Mode = "movingBlockLine";
      switchKey = -1;
    }
    
  }else if (key =='l' || key == 'L') {      //saves to file
    chosenLevel=1+chosenLevel%int(filehandler.getlatestLevel());
    resetAll();
    filehandler.callBlocks(filehandler.readData());
    lvlloaded = true;
  }
}
