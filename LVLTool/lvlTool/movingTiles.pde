void addMovingBlock(){
  if (Mode != "movingBlockLine") 
    return;
  int xscaled = 0;
  int yscaled = 0;
  xscaled = round(((mouseX+scale/2)/scale))*scale;
  yscaled = round(((mouseY+scale/2)/scale))*scale;
  noLines.circle(xscaled, yscaled, 5); 
}

void drawMovingTiles(){
  int start = 0;
  for (int i=0; i<maxMovingLine-1; i++) {
    boolean startfound = false;
    noLines.stroke(0);
    if (i>start && BlockLine[i][0] == BlockLine[start][0] && BlockLine[i][1] == BlockLine[start][1]) {
      start = i+1;
      startfound = true;
    }
    if (BlockLine[0][0] != -10 && startfound == false)
      noLines.line(BlockLine[i][0], BlockLine[i][1], BlockLine[i+1][0], BlockLine[i+1][1]);
  }
}
