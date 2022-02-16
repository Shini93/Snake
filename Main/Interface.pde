import interfascia.*;
boolean shopmenu = false;
GUIController Menu, lvlSettings, backHandler, ShopHandler;
IFButton start, settings, levelsetting, back, shop;
IFButton[] levels = new IFButton [10];
PImage[] img = new PImage[10];
PImage imgLock;
boolean GameStart = false;
boolean[] deactivateButton = new boolean[3];
DataHandler datahandler = new DataHandler();


void setup() {
  size(1200, 1000);                          //starting size of the game
  IFLookAndFeel greenLook = new IFLookAndFeel(this, IFLookAndFeel.DEFAULT);
  greenLook.baseColor = color(100, 180, 100);
  greenLook.highlightColor = color(70, 135, 70);
  Menu = new GUIController (this);
  Menu.setLookAndFeel( greenLook);
  start = new IFButton ("\nSTART", width/2-150, height/2-1*height/10, 300, 40);
  levelsetting = new IFButton ("\nLevel", width/2-150, height/2, 300, 40);
  shop = new IFButton ("\nShop", width/2-150, height/2+height/10, 300, 40);
  settings = new IFButton ("\nSETTINGS", width/2-150, height/2+2*height/10, 300, 40);
  start.addActionListener(this);
  levelsetting.addActionListener(this);
  settings.addActionListener(this);
  shop.addActionListener(this);

  Menu.add (start);
  Menu.add (levelsetting);
  Menu.add (settings);
  Menu.add (shop);
  datahandler.readJson();
  
}

//TODO: show Stats: Killcount, Foodcount
//TODO: Buy other skins for the snake/Food/Blocks



void actionPerformed (GUIEvent e) {
  if (e.getSource() == start && deactivateButton[0] == false) {
    Menu.setVisible(false);
    SetupSnake();
    GameStart = true;
    deactivateButton[0] = true;
  } else if (e.getSource() == levelsetting && deactivateButton[0] == false) {
    levelSettingsInit();
    deactivateButton[0] = true;
  }else if (e.getSource() == settings && deactivateButton[0] == false) {
    background(100, 100, 130);
    deactivateButton[0] = true;
  }else if (e.getSource() == shop && deactivateButton[0] == false) {
    Menu.setVisible(false);
    background(100, 100, 130);
    shopmenu = true;
    deactivateButton[0] = true;
  }
  else if (e.getSource() == back) {
    lvls.lvlSelect = -1;
    deactivateButton[1] = true;
    deactivateButton[0] = false;
    lvlSettings.setVisible(false);
    backHandler.setVisible(false);
    background(100, 100, 130);
    Menu.setVisible(true);
  }
  else{
    if(deactivateButton[1] == false){
      for(int i=0;i<lvl.maxLvl;i++){
        if(i>=maxLevel)
          return;
        if (e.getSource() == levels[i]) {
          deactivateButton[1] = true;
          lvls.lvlSelect = byte(i+1); //<>//
          lvlSettings.setVisible(false);
          backHandler.setVisible(false);
          SetupSnake();
          GameStart = true; //<>//
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
  back = new IFButton("\nBack",width/2-125,height-150,250,50);
  back.addActionListener(this);
  backHandler.add(back);
  //lvls.start();
  lvls.getLatestLevel();
  lvlSettings.setVisible(false);
  for(int i=0;i<lvl.maxLvl;i++){
     int x = width/40+width/4*(i%4);
     int y = 100*floor((i+4)/4)+height/10*floor(i/4);
     levels[i] = new IFButton("level "+i,x,y,width/5,height/10); 
     levels[i].addActionListener(this);
     lvlSettings.add (levels[i]);
     img[i] = loadImage("/data/lvlpics/lvl"+(i+1)+".png");
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
     } //<>//
  } 
}
color shopMenu(color farbe){
  float red = red(farbe);
  float green = green(farbe);
  float blue = blue(farbe);

  if(second() %3 == 0 && counter == true){
    red = random(255);
    green =random(255);
    blue = random(255);
    counter = false;
  }
  if(second() %3 != 0)
    counter = true;
  float frequency = 2*PI/30;
  float offsetfrequency = (millis()*0.01)%(2*PI);
  int offsetx = 400;
  int offsety = 500;
  int size = 30;
  int stepsize = 5;
  int amplitude = 20;
  int NumberBody = 60;
  background(100, 100, 130);
  for(int i=0;i<NumberBody;i+=2){
    fill(color((NumberBody-i)*red/NumberBody,(NumberBody-i)*green/NumberBody,(NumberBody-i)*blue/NumberBody)); 
    circle(offsetx+i*stepsize,offsety+amplitude*sin( i*frequency+offsetfrequency),size);
  }
  return color(red,green,blue);
}
