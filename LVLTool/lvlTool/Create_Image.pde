void createImage(){ 
  willDraw = true;
  noLines.background(125);
  draw();
  int level = filehandler.getlatestLevel();
  if(lvlloaded == true){
    level = chosenLevel;
  }
  noLines.save("../../Main/data/lvlpics/lvl"+level+".png");
}
