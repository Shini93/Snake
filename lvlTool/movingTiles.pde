void addMovingBlock(){
  if (Mode != "movingBlockLine") 
    return;
  int xscaled = 0;
  int yscaled = 0;
  int sc = round(scale*scaleFact);
  xscaled = round(((mouseX+sc/2)/sc))*sc;
  yscaled = round(((mouseY+sc/2)/sc))*sc;
  noLines.circle(xscaled, yscaled, 5); 
}

void drawMovingTiles(){
  int start = 0;
  ellipse(BlockLine[0][0]*scaleFact, BlockLine[0][1]*scaleFact,5*scaleFact,5*scaleFact);
  for (int i=0; i<maxMovingLine-1; i++) {
    ellipse(BlockLine[i+1][0]*scaleFact, BlockLine[i+1][1]*scaleFact,5*scaleFact,5*scaleFact);
    boolean startfound = false;
    noLines.stroke(0);
    if (i>start && BlockLine[i][0] == BlockLine[start][0] && BlockLine[i][1] == BlockLine[start][1]) {
      start = i+1;
      startfound = true;
    }
    if (BlockLine[0][0] != -10 && startfound == false)
      noLines.line(BlockLine[i][0]*scaleFact, BlockLine[i][1]*scaleFact, BlockLine[i+1][0]*scaleFact, BlockLine[i+1][1]*scaleFact);
  }
}
