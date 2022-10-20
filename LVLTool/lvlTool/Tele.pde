void addTele(){
  if (Mousepressed == false || Mode != "Portals") 
    return;
  int xscaled = 0;
  int yscaled = 0;
  
  xscaled = round(((mouseX+scale/2)/scale))*scale;
  yscaled = round(((mouseY+scale/2)/scale))*scale;
  boolean exists = false;
  for(int i=0;i<maxPortal;i++){
    if(xscaled == Tele[i][0] && yscaled == Tele[i][1]){
       exists = true; 
    }
  }
  if(exists == false){
    Tele[maxPortal][0] = xscaled;
    Tele[maxPortal][1] = yscaled;
    maxPortal++;
  }
  
}

void drawTele(){
  
  for (int i=0; i<maxPortal; i++) {
    noLines.fill(#FFFF00);
    noLines.ellipse(Tele[i][0], Tele[i][1], 10, 20);    
  }
  noLines.fill(#FFFFFF);
}
