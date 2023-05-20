class GUIPage {
  ArrayList <Button> Buttons = new ArrayList <Button>();
  String name;
  Boolean active = false;

  GUIPage(String name) {
    this.name = name;
  }

  //adds initialized button
  void addButton(Button button) {
    Buttons.add(button.clone());
  }

  //adds initialized button
  void addButton(int x1, int y1, String text1) {
    Buttons.add(new Button(x1, y1, text1));
  }
  
  //adds initialized button
  void addButton(int x1, int y1, int x2, int y2, String text1) {
    Buttons.add(new Button(x1, y1, x2, y2, text1));
  }
  
  //adds initialized button
  void addButton(float x1, float y1, float x2, float y2, String text1) {
    Buttons.add(new Button(round(x1), round(y1), round(x2), round(y2), text1));
  }
  
  //adds initialized button
  void addButton(int x1, int y1, int x2, int y2, String text1, int z) {
    Buttons.add(new Button(x1, y1, x2, y2, text1, z));
  }

  //single buton fires
  boolean isFired(int b) {
    //log.append("guiPage.isFired");
    if (active == false)
      return false;
    if (Buttons.get(b).isFired())
      return true;
    return false;
  }

  //all buttons tested
  int isFired() {
    //log.append("guiPage.isFired");
    if (active == false)
      return -1;
    for (int b = 0; b < Buttons.size(); b++) {
      if (isFired(b) == true)
        return b;
    }
    return -2;
  }

  //mouseOverTest single
  boolean isMouseOver(int b) {
    //log.append("guiPage.isMouseOver");
    if (active == false)
      return false;
    if (Buttons.get(b).isMouseOver())
      return true;
    return false;
  }

  //mouseOverTest all
  int isMouseOver() {
    //log.append("guiPage.isMouseOver");
    if (active == false)
      return -1;
    for (int b = 0; b < Buttons.size(); b++) {
      if (Buttons.get(b).isMouseOver())
        return b;
    }
    return -1;
  }

  //Draws Buttons
  void DrawButtons() {
    //log.append("guiPage.DrawButtons");
    if (active == false)
      return;
    for (int b = 0; b < Buttons.size(); b++) {
      Buttons.get(b).DrawButton();
    }
  }
  
  Button getButton(String name){
    //log.append("guiPage.getButton");
    for(int b = 0; b < Buttons.size(); b++)
      if(Buttons.get(b).text == name)
        return Buttons.get(b);
    return new Button(0,0,"");
  }
  
  int getButtonID(String name){
    //log.append("guiPage.getButtonID");
    for(int b = 0; b < Buttons.size(); b++)
      if(Buttons.get(b).text == name)
        return b;
    return-1;
  }
  void reset(){
    //log.append("guiPage.reset");
    for(int b = Buttons.size() - 1; b >=0; b--)
      Buttons.remove(b);
  }
}

int getGuiPageID(String pageName){
  //log.append("guiPage.getGuiPageID");
  for(int p = 0; p < guiPages.length; p++)
    if(guiPages[p].name == pageName)
      return p;
  return -1;
}

class Button { //<>// //<>// //<>// //<>// //<>//
  int deltaT =0;
  color c = colorscheme[2];
  color bgc = colorscheme[3];
  String text = "Button 1g dthdxhdygfysd s  rsy g";
  PImage image;
  Boolean imageOn = false;
  Boolean isActive = true;
  int x = 0;
  int y = sizeFont;
  int boxSizeX = 300;
  int boxSizeY = sizeFont;
  int opacity = 255;
  int mouseOverTime = -1;
  int mouseOverSince = 0;

  void initButton() {
    //log.append("button.initButton");
    DrawButton();
  }
  Button(int x1, int y1, String text1) {
    x=x1;
    y=y1+sizeFont;
    text = text1;
    initButton();
  }
  Button(int x1, int y1, String text1, String imgPath) {
    x=x1;
    y=y1+sizeFont;
    text = text1;
    initButton();
    imageOn = true;
    image = loadImage(imgPath);
  }
  Button(int x1, int y1, int x2, int y2, String text1) {
    x=x1;
    y=y1+sizeFont;
    boxSizeX = x2;
    boxSizeY = y2;
    text = text1;
    initButton();
  }
  Button(int x1, int y1, int x2, int y2, String text1, int opacityy) {
    x=x1;
    opacity = opacityy;
    y=y1+sizeFont;
    boxSizeX = x2;
    boxSizeY = y2;
    text = text1;
    initButton();
  }
  Button(int x1, int y1, String text1, color c1, color bg) {
    x=x1;
    y=y1+sizeFont;
    text = text1;
    c = c1;
    bgc = bg;
    initButton();
  }
  Button(int x1, int y1, String text1, color c1, color bg, int size) {
    x=x1;
    y=y1+sizeFont;
    text = text1;
    c = c1;
    bgc = bg;
    y = size;
    initButton();
  }

  Button clone() {
    //log.append("button.clone");
    Button dummy = new Button(0, 0, "");
    dummy.bgc = bgc;
    dummy.boxSizeX = boxSizeX;
    dummy.boxSizeY = boxSizeY;
    dummy.c = c;
    dummy.image = image;
    dummy.imageOn = imageOn;
    dummy.opacity = opacity;
    dummy.text = text;
    dummy.x = x;
    dummy.y = y;
    return dummy;
  }

  void ButtonSize(){
    
  }

  void DrawButton() {
    //log.append("button.DrawButton");
    int dS = 0;
    int dSBig = 30;
    if(mouseOverSince != 0){
      dS = dSBig;
    }
    noStroke();
    fill(BackgroundColor);
    rect( x - dSBig/2, y-boxSizeY - dSBig/2, boxSizeX+dSBig, boxSizeY+dSBig);
    if (imageOn == true)
      image(image, x - dS/2, y-boxSizeY - dS/2, boxSizeX+dS, boxSizeY+dS);
    else {
      fill(bgc, opacity);
      rect(x - dS/2, y-boxSizeY-dS/2, boxSizeX+dS, boxSizeY+dS);
      fill(c, opacity);
      textAlign(CENTER, BOTTOM);
      textSize(g.textSize + dS/4);
      text(text, x+int(boxSizeX)/2, y + dS/8);
      textSize(g.textSize - dS/4);
    }
  }

  Boolean isFired() {
    //log.append("button.isFired");
    if(isActive == false)
      return false;
    if (isMouseOver() == false)
      return false;
    if (mousePressed  == false)
      return false;
    if (deltaT>0)
      if (millis()-deltaT < 200)
        return false;
    deltaT = millis();
    guiSound[1].play();
    return true;
  }

  Boolean isMouseOver() {
    //log.append("button.isMouseOver");
    if(isActive == false)
      return false;
    if (mouseX<x){
      mouseOverTime = -1;
      mouseOverSince = 0;
      return false;
    }
    if (mouseX > x+boxSizeX){
      mouseOverTime = -1;
      mouseOverSince = 0;
      return false;
    }
    if (mouseY < y-boxSizeY+3){
      mouseOverTime = -1;
      mouseOverSince = 0;
      return false;
    }
    if (mouseY > y+ 6){
      mouseOverTime = -1;
      mouseOverSince = 0;
      return false;
    }
    if(mouseOverTime == -1){
      mouseOverTime = millis();
      guiSound[0].play();
    }
    mouseOverSince = millis() - mouseOverTime;
    return true;
  }

  void addImage(String imgPath) {
    imageOn = true;
    image = loadImage(imgPath);
    //   image.resize(boxSizeX, boxSizeY);
  }

  void deleteImage() {
    imageOn = false;
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
