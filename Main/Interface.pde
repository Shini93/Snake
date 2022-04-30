import interfascia.*;
 //<>//

void initButtons(){
  
  IFLookAndFeel greenLook = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
  greenLook.baseColor = color(100, 180, 100);
  greenLook.highlightColor = color(70, 135, 70);
  Menu = new GUIController (this);
  Menu.setLookAndFeel( greenLook);
  
  start = addButton(this,Menu,start,"\nSTART",width/2-150, height/2-1*height/10, 300, 40);
  levelsetting = addButton(this,Menu,levelsetting,"\nLevel", width/2-150, height/2, 300, 40);
  shop = addButton(this,Menu,shop,"\nShop", width/2-150, height/2+height/10, 300, 40);
  settings = addButton(this,Menu,settings,"\nSETTINGS", width/2-150, height/2+2*height/10, 300, 40);
}
 
void actionPerformed (GUIEvent e) {
  /********************************
  *1. Level
  ********************************/
  if (e.getSource() == start && deactivateButton[0] == false) {          //Startbutton
    Menu.setVisible(false);
    SetupSnake();
    GameStart = true;
    deactivateButton[0] = true;
  }else if (e.getSource() == levelsetting && deactivateButton[0] == false) {  //LevelButton
    levelSettingsInit();
    deactivateButton[0] = true;
  }else if (e.getSource() == settings && deactivateButton[0] == false) {      //SettingsButton
    background(100, 100, 130);
    deactivateButton[0] = true;
  }else if (e.getSource() == shop && deactivateButton[0] == false) {          //ShopButton
    datahandler.savetoJson();
    Menu.setVisible(false);
    background(100, 100, 130);
    shopmenu = true;
    deactivateButton[0] = true;
    shopMenu();
  }
  /********************************
  *Shop
  ********************************/
  else if (e.getSource() ==s_back) {                                          //left Skin
    SnakeColorSelected--;
    if(SnakeColorSelected<0)
      SnakeColorSelected = SnakeColor.length-1;
    if(boughtItems[SnakeColorSelected] == true){
      buy.setLabel("\nchoose");
      fill(100,100,130);
      noStroke();
      rect(width/2-width/10,600, width/10, 50);
      fill(#FFFBA2);
      text("choose",width/2-width/10,640);
    }else{
      buy.setLabel("\nbuy");
      fill(100,100,130);
      noStroke();
      rect(width/2-width/10, 600, width/10, 50);
      fill(#FFFBA2);
      text("Buy",width/2-width/10,640);
    }
  }
  else if (e.getSource() ==s_forward) {                                        //right skin
    SnakeColorSelected++;
    if(SnakeColorSelected>=SnakeColor.length)
      SnakeColorSelected = 0;
    if(boughtItems[SnakeColorSelected] == true){
      buy.setLabel("\nchoose");
      fill(100,100,130);
      noStroke();
      rect(width/2-width/10,600, width/10, 50);
      fill(#FFFBA2);
      text("choose",width/2-width/10,640);
    }else{
      buy.setLabel("\nbuy");
      fill(100,100,130);
      noStroke();
      rect(width/2-width/10, 600, width/10, 50);
      fill(#FFFBA2);
      text("Buy",width/2-width/10,640);
    }
  }
  else if (e.getSource() ==buy) {                                              //BuyButton
    buySkin();
  }
  else if (e.getSource() == backShop){                                         //shop->overview
    background(100, 100, 130);
    Menu.setVisible(true);
    ShopHandler.setVisible(false);
    SnakeColorSelected = SnakeNormalColor;
    shopmenu = false;
    deactivateButton[0] = false;
  }
  /********************************
  *levelSettings
  ********************************/
  else if (e.getSource() == back) {                                            //level->overview
    lvls.lvlSelect = -1;
    deactivateButton[1] = true;
    deactivateButton[0] = false;
    lvlSettings.setVisible(false);
    backHandler.setVisible(false);
    background(100, 100, 130);
    Menu.setVisible(true);
  }
  else{                                                                        //level selector
    if(deactivateButton[1] == false){
      for(int i=0;i<lvl.maxLvl;i++){
        if(i>=maxLevel)
          return;
        if (e.getSource() == levels[i]) {
          deactivateButton[1] = true;
          lvls.lvlSelect = byte(i+1);
          lvlSettings.setVisible(false);
          backHandler.setVisible(false);
          SetupSnake();
          GameStart = true;
        }
      }
    }
  }
}

void levelSettingsInit(){
  Menu.setVisible(false);
  deactivateButton[1] = false;
  background(125);
  lvlSettings = new GUIController(this);
  backHandler = new GUIController(this);
  
  back = addButton(this,backHandler,back,"\nBack",width/2-125,height-150,250,50);
  
  //lvls.start();
  lvls.getLatestLevel();
  lvlSettings.setVisible(false);
  for(int i=0;i<lvl.maxLvl;i++){
     int x = width/40+width/4*(i%4); //<>// //<>// //<>//
     int y = 100*floor((i+4)/4)+height/10*floor(i/4);
     levels[i] = addButton(this,lvlSettings,levels[i],"level "+i,x,y,width/5,height/10);
     
     String test = str(i+1);
     img[i] = loadImage("/data/lvlpics/lvl"+test+".png");
     img[i].resize(width/5,height/10);
     img[i].filter(100);
     if(i>=maxLevel)
      tint(70,70);
     image(img[i],x,y);
     if(i>=maxLevel){
      imgLock = loadImage("/data/lock.png");
      imgLock.resize(width/5,height/10);
      noTint();
      image(imgLock,x,y);
     }
  } 
}

void shopMenu(){
  ShopHandler = new GUIController (this);
  
  s_back = addButton(this,ShopHandler,s_back,"\nBack", width/10, 500-20, width/10, 40);
  s_forward = addButton(this,ShopHandler,s_forward,"\nNext", 8*width/10, 500-20, width/10, 40);
  buy = addButton(this,ShopHandler,buy,"\nBuy", width/2-width/10, 600, width/10, 40);
  

  ShopHandler.showBounds = true;
  backShop = addButton(this,ShopHandler,backShop,"\nBack", width/2-width/3, 600, width/10, 40);

  ShopHandler.setVisible(false);
  SnakeNormalColor = SnakeColorSelected;
  fill(0);
  
  triangle(width/10,500,2*width/10,520,2*width/10,480);
  triangle(9*width/10,500,8*width/10,520,8*width/10,480);  
  textSize(30);
  fill(#FFFBA2);
  text("Costs 5000 food",width/2-150,400);
  text("Buy",width/2-width/10,640);
  text(maxFood+" food",width/10,100);
  text("Startseite",width/2-width/3,640);
}

void showSnake(){
  float frequency = 2*PI/30;
  float offsetfrequency = (millis()*0.01)%(2*PI);
  int offsetx = 450;
  int offsety = 500;
  int size = 30;
  int stepsize = 5;
  int amplitude = 20;
  int NumberBody = 60;
  
  fill(255);
  noStroke();
  rect(offsetx-size/2,offsety-size/2-amplitude,60*5+31,amplitude+2*size-10);
  stroke(0);
  for(int i=0;i<=NumberBody;i+=2){
    float newRed =   (NumberBody-i)*red  (SnakeColor[SnakeColorSelected])/NumberBody;
    float newGreen = (NumberBody-i)*green(SnakeColor[SnakeColorSelected])/NumberBody;
    float newBlue =  (NumberBody-i)*blue (SnakeColor[SnakeColorSelected])/NumberBody;
    fill(color(newRed,newGreen,newBlue)); 
    ellipse(offsetx+i*stepsize,offsety+amplitude*math.sinS( i*frequency+offsetfrequency),size,size);
  } 
}

void buySkin(){
   if(buy.getLabel()=="\nchoose"){
       SnakeNormalColor = SnakeColorSelected;
       boughtItems[SnakeColorSelected] = true;
       datahandler.savetoJson();
   }else{
     if(maxFood>=5000){
       maxFood-=5000;
       SnakeNormalColor = SnakeColorSelected;
       boughtItems[SnakeColorSelected] = true;
       datahandler.savetoJson();
       buy.setLabel("\nchoose");
     }  
   }
}

/*******************************
*Adds Button to guicontroller
*******************************/
IFButton addButton(Object meh,GUIController ctrl, IFButton btn, String label, int x1,int y1,int x2,int y2){
  btn = new IFButton (label, x1, y1, x2, y2);
  btn.addActionListener(meh);
  ctrl.add (btn);
  return btn;
}
