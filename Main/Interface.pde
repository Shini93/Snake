 //<>//
class Button{
   int deltaT =0;
   color c = colorscheme[2];
   color bgc = colorscheme[0];
   String text = "Button 1g dthdxhdygfysd s  rsy g"; 
   int x = 0;
   int y = sizeFont;
   int boxSizeX = 300;
   int boxSizeY = 30;
   int opacity = 255;
   void initButton(){
     DrawButton();
   }
   Button(int x1, int y1, String text1){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, int x2, int y2, String text1){
     x=x1;
     y=y1+sizeFont;
     boxSizeX = x2;
     boxSizeY = y2;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, int x2, int y2, String text1, int opacityy){
     x=x1;
     opacity = opacityy;
     y=y1+sizeFont;
     boxSizeX = x2;
     boxSizeY = y2;
     text = text1;
     initButton();
   }
   Button(int x1, int y1, String text1, color c1, color bg){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     c = c1;
     bgc = bg;
     initButton();
   }
   Button(int x1, int y1, String text1, color c1, color bg, int size){
     x=x1;
     y=y1+sizeFont;
     text = text1;
     c = c1;
     bgc = bg;
     sizeFont = size;
     initButton();
   }
   void DrawButton(){
     noStroke();
     fill(bgc, opacity);
     rect(x,y-boxSizeY+3,boxSizeX,boxSizeY+6);
     fill(c, opacity);
     text(text,x+int(boxSizeX-textWidth(text))/2,y-2*boxSizeY+10);
   }
   Boolean isFired(){
     if(mousePressed  == false)
       return false;
     if(mouseX<x) 
       return false;
     if(mouseX > x+boxSizeX)
       return false;
     if(mouseY < y-boxSizeY+3)
       return false;
     if(mouseY > y+ 6)
       return false;
     if(deltaT>0)
       if(millis()-deltaT < 200)
         return false;
     deltaT = millis();
    return true;  
   } 
}


void initButtons(){

  start = new Button(width/2-150, height/2-1*height/10,"\nSTART");
  levelsetting = new Button( width/2-150, height/2,"\nLevel");
  shop = new Button( width/2-150, height/2+height/10,"\nShop");
  settings = new Button(width/2-150, height/2+2*height/10,"\nSETTINGS");
  for(int i=1;i<3;i++)
    deactivateButton[i] = true;
}
 
 void checkFeedback(){
    /********************************
    *1. Level
    ********************************/
    if(deactivateButton[0] == false){        
      if( start.isFired()==true){
        SetupSnake();
        GameStart = true;
        deactivateButton[0] = true;
      }else if (levelsetting.isFired() == true) {  //LevelButton
        levelSettingsInit();
        deactivateButton[0] = true;
      }else if (shop.isFired()) {          //ShopButton
        datahandler.savetoJson();
        background(100, 100, 130);
        shopmenu = true;
        deactivateButton[0] = true;
        shopMenu();
      }else if (settings.isFired()) {      //SettingsButton
        background(100, 100, 130);
        deactivateButton[0] = true;
        initButtons();
      }
    }
  /********************************
  *Shop
  ********************************/
  if(deactivateButton[2] == false){      
    if (s_back.isFired()) {                                          //left Skin
      SnakeColorSelected--;
      if(SnakeColorSelected<0)
        SnakeColorSelected = SnakeColor.length-1;
      if(boughtItems[SnakeColorSelected] == true){
        buy.text="\nchoose";
      }else{
        buy.text="\nbuy";
      }
      buy.DrawButton();
    }
    else if (s_forward.isFired()) {                                        //right skin
      SnakeColorSelected++;
      if(SnakeColorSelected>=SnakeColor.length)
        SnakeColorSelected = 0;
      if(boughtItems[SnakeColorSelected] == true){
        buy.text = "\nchoose";
      }else{
        buy.text = "\nbuy";
      }
      buy.DrawButton();
    }
    else if (buy.isFired()) {                                              //BuyButton
      buySkin();
    }
    else if (backShop.isFired()){                                         //shop->overview
      background(100, 100, 130);
      initButtons();
      SnakeColorSelected = SnakeNormalColor;
      shopmenu = false;
      deactivateButton[0] = false;
    }
  }
  /********************************
  *levelSettings
  ********************************/
  
  else if(deactivateButton[1] == false){                                                                             //level selector
      for(int i=0;i<lvl.maxLvl;i++){
        if(i>=maxLevel)
          return;
        if (levels[i].isFired()) {
          deactivateButton[1] = true;
          lvls.lvlSelect = byte(i+1);
          SetupSnake();
          GameStart = true;
        }
      }
      if(back.isFired()) {                                            //level->overview
        lvls.lvlSelect = -1;
        deactivateButton[1] = true;
        deactivateButton[0] = false;
        background(100, 100, 130);
        initButtons();
      }
    }
  
   
 }
 

void levelSettingsInit(){
  deactivateButton[1] = false;
  background(125);
  
  back = new Button(width/2-125,height-150,"\nBack");
  
  lvls.getLatestLevel();
  for(int i=0;i<lvl.maxLvl;i++){
     int x = width/40+width/4*(i%4); //<>// //<>// //<>//
     int y = 100*floor((i+4)/4)+height/10*floor(i/4);
     levels[i] = new Button(x,y+height/10,width/5,height/10,"level "+i, 0);    //x1,y1,x2,y2,text,opacity
     
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
  deactivateButton[2] = false;
  s_back = new Button(width/10, 500-20,width/10, 30,"\nBack", 0);
  s_forward = new Button(8*width/10, 500-20, width/10, 30,"\nNext",0);
  buy = new Button( width/2-width/10, 600,"\nBuy");
  
  backShop = new Button(width/2-width/3, 600,"\nBack");

  SnakeNormalColor = SnakeColorSelected;
  fill(0);
  
  triangle(width/10,500,2*width/10,520,2*width/10,480);
  triangle(9*width/10,500,8*width/10,520,8*width/10,480);  
  textSize(30);
  fill(#FFFBA2);
  text("Costs 5000 food",width/2-150,400);
  text(maxFood+" food",width/10,100);
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
   if(buy.text=="\nchoose"){
       SnakeNormalColor = SnakeColorSelected;
       boughtItems[SnakeColorSelected] = true;
       datahandler.savetoJson();
   }else{
     if(maxFood>=5000){
       maxFood-=5000;
       SnakeNormalColor = SnakeColorSelected;
       boughtItems[SnakeColorSelected] = true;
       datahandler.savetoJson();
       buy.text="\nchoose";
     }  
   }
}
