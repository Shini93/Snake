//reverses Blocks on screen 
void ReverseBlocks(){
  ArrayList <Integer> dummyX = new ArrayList<Integer>();
  ArrayList <Integer> dummyY = new ArrayList<Integer>();
  for (int i=0; i<width/scale+1; i++) {
    for (int k=0; k<height/scale+1; k++) {
      boolean exists = false;
      for (int j=0; j<blocksy.size(); j++) {
        if ( round((i)*scale) == blocksx.get(j) && round((k)*scale) == blocksy.get(j)) {
          exists = true;
        }
      }
      if (exists == false) {
        dummyX.add(round((i)*scale));
        dummyY.add(round((k)*scale));
      }
    }
  }
  blocksx = dummyX;
  blocksy = dummyY; 
}

void addBlock() {
  if (Mousepressed == false || Mode != "Blocks")
    return;
  int xscaled = round(ImouseX/scale)*scale;
  int yscaled = round(ImouseY/scale)*scale;
  boolean exists = false;
  
  for (int i=blocksx.size()-1; i>=0; i--) {
    if (blocksx.size() > 0 && blocksx.get(i) == xscaled && blocksy.get(i) == yscaled) {
      exists = true;
      if (keyPressed && key=='d') {
        blocksx.remove(i);
        blocksy.remove(i);
      }
    }
  }
  if (exists == false && keyPressed==false) {
    blocksx.add(xscaled);
    blocksy.add(yscaled);
  }
}

void drawBlock(){
  for (int i=0; i<blocksx.size(); i++) {
    noLines.rect(blocksx.get(i), blocksy.get(i), scale, scale);
    noLines.fill(#00FFFF);
    noLines.circle(snake[0], snake[1], 10);
    noLines.fill(#FFFFFF);
  }
}
