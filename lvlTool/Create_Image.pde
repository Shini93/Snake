void createImage(){ 
  willDraw = true;
  draw();
  int level = filehandler.getlatestLevel();
  if(lvlloaded == true){
    level = chosenLevel;
  }
  saveFrame("../../Main/data/lvlpics/lvl"+level+".png");
}
