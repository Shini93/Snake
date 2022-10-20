void  ReverseFood(){
  int[][] dummy = new int[1000][2];
  int maxDummy = 0;
  for (int i=0; i<width/scale+1; i++) {
    for (int k=0; k<height/scale+1; k++) {
      boolean exists = false;
      for (int j=0; j<maxFood; j++) {
        if ( round((i)*scale) == Food[j][0] && round((k)*scale) == Food[j][1]) {
          exists = true;
        }
      }
      if (exists == false) {
        dummy[maxDummy][0] = round(i)*scale;
        dummy[maxDummy][1] = round(k)*scale;
        maxDummy++;
        if(maxDummy >998){
          maxFood = maxDummy;
          Food = dummy;
          return;
        }
          
      }
    }
  }
  maxFood = maxDummy;
  Food = dummy;
}

void addFood(){
  if (Mousepressed == false || Mode != "Food") 
    return;
  int xscaled = 0;
  int yscaled = 0;
  boolean exists = false;
  
  xscaled = round(((ImouseX+scale/2)/scale))*scale;
  yscaled = round(((ImouseY+scale/2)/scale))*scale;
  
  for(int i=0;i<maxFood;i++){
    if(xscaled == Food[i][0] && yscaled == Food[i][1]){
       exists = true; 
       if (keyPressed && key=='d') {
          for(int j=i;j<maxFood;j++){
             Food[j][0] = Food[j+1][0];
             Food[j][1] = Food[j+1][1];
          }
          maxFood--;
      }
    }
  }
  if(exists == false && keyPressed==false){
    Food[maxFood][0] = xscaled;
    Food[maxFood][1] = yscaled;
    maxFood++;
  }
}

void drawFood(){
  for (int i=0; i<maxFood; i++) {
    noLines.fill(#0000FF);
    noLines.ellipse(Food[i][0], Food[i][1], 10, 10);    
  }
  noLines.fill(#FFFFFF);
}
