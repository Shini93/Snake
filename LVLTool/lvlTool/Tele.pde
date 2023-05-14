void addTele(){
  if (Mousepressed == false || Mode != "Portals") 
    return;
  int xscaled = 0;
  int yscaled = 0;
  
  xscaled = round(((ImouseX+scale/2)/scale))*scale;
  yscaled = round(((ImouseY+scale/2)/scale))*scale;
  boolean exists = deleteTele(xscaled,yscaled);

  if(exists == false && keyPressed == false){
    Tele[maxPortal][0] = xscaled;
    Tele[maxPortal][1] = yscaled;
    maxPortal++;
  }
  
}

void drawTele(){
  int c = 0; 
  for (int i=0; i<maxPortal; i++) {
    if(i%2 == 0)
      c++;
    color tele = color(255*noise(100*c),255*noise(125*(c+1)),255*noise(175*(c+3)));
    noLines.fill(tele);
    noLines.ellipse(Tele[i][0]*scaleFact, Tele[i][1]*scaleFact, 10*scaleFact, 20*scaleFact);    
    text(i, Tele[i][0]*scaleFact+5*scaleFact, Tele[i][1]*scaleFact-5*scaleFact);
  }
  noLines.fill(#FFFFFF);
}

boolean deleteTele(int xscaled, int yscaled){
  boolean exists = false;
  for(int i=0;i<maxPortal;i++){
    if(xscaled == Tele[i][0] && yscaled == Tele[i][1]){
       exists = true; 
       if (keyPressed && key=='d') {
          for(int j=i;j<maxPortal;j++){
             Tele[j][0] = Tele[j+1][0];
             Tele[j][1] = Tele[j+1][1];
          }
          maxPortal--;
      }
    }
  }
  return exists;
}
