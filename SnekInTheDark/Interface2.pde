//Buttons from startScreen //<>// //<>// //<>// //<>//
void initButtonsStartScreen() {
  //log.append("Interface2.initButtonsStartScreen");
  guiPages[0].addButton(dWidth/2-150, dHeight/2-2*dHeight/10, "Start");
  guiPages[0].addButton(dWidth/2-150, dHeight/2 - dHeight/10, "Level");
  guiPages[0].addButton(dWidth/2-150, dHeight/2+ 0*dHeight/10, "Shop");
  guiPages[0].addButton(dWidth/2-150, dHeight/2+1*dHeight/10, "Settings");
  guiPages[0].addButton(dWidth/2-150, dHeight/2+2*dHeight/10, "Exit");
  guiPages[0].active = true;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
void initButtonsLevelScreen() {
  //log.append("Interface2.initButtonsLevelScreen");
  background(BackgroundColor);
  println("lvl");
  guiPages[1].reset();
  guiPages[1].addButton(dWidth/2-125, dHeight-150, "Back");
  lvls.getLatestLevel();
  for (int i=0; i<maximumDesignLvl; i++) {
    int x = dWidth/40+dWidth/4*(i%4);
    int y = 100*floor((i+4)/4)+dHeight/10*floor(i/4);
    guiPages[1].addButton(x, y, dWidth/5, dHeight/10, "level "+i, 0);

    String test = str(i+1);
    guiPages[1].Buttons.get(i+1).addImage("lvlpics/lvl"+test+".png");    //0 is Back button.
    guiPages[1].Buttons.get(i+1).image.filter(100);


    if ( i >= maxReachedLvl) {
      guiPages[1].Buttons.get(i+1).addImage("lock.png");
    }

    guiPages[1].Buttons.get(i+1).DrawButton();
    //  if (i<=maxLevel + 2) {
    //if(isAndroid == true)
    //  imgLock = loadImage("lock.png");
    //else
    //  imgLock = loadImage("/data/lock.png");
    //imgLock.resize(dWidth/5, dHeight/10);
    //noTint();
    //image(imgLock, x, y);
    // }
    noTint();
  }
}

//Buttons from shopScreen
void initButtonsShopScreen() {
  //log.append("Interface2.initButtonsShopScreen");
  guiPages[2].addButton(dWidth/10, 460, dWidth/10, 40, "Back", 0);
  guiPages[2].addButton(8*dWidth/10, 460, dWidth/10, 40, "Next", 0);
  guiPages[2].addButton(dWidth/2-dWidth/10, 600, "Buy");
  guiPages[2].addButton(dWidth/2-dWidth/3, 600, "Return");
  guiPages[2].active = true;
}

//Checks Buttons on main page
void checkMainFired(GUIPage p, int firedButton) {
  //log.append("Interface2.checkMainFired");
  p.active = false;
  if (p.Buttons.get(firedButton).text == "Start") {
    SetupSnake();
    GameStart = true;
    return;
  }
  if (p.Buttons.get(firedButton).text == "Level") {
    guiPages[1].active = true;                      //LevelPage gets accessable
    initButtonsLevelScreen();
    return;
  }
  if (p.Buttons.get(firedButton).text == "Shop") {
    datahandler.savetoJson(getJsonPath());
    guiPages[2].active = true;
    shopmenu = true;
    shopMenu();
    return;
  }
  if (p.Buttons.get(firedButton).text == "Settings") {
    p.active = true;
    return;
  }
  if (p.Buttons.get(firedButton).text == "Exit") {
    datahandler.savetoJson(getJsonPath());
    exit();
  }
}

//Checks feedback from active Page.
void checkFeedback() {
  //log.append("Interface2.checkFeedback");
  for (GUIPage p : guiPages) {
    if (p.active == false)
      continue;
    // p.isMouseOver();
    p.DrawButtons();
    if (p.name == "Shop")
      drawShopTexts();
    int firedButton = p.isFired();
    if (firedButton < 0)
      continue;

    if (p.name == "Main") {
      checkMainFired(p, firedButton);
      return;
    }
    //------------------------------------------------
    if (p.name == "Level") {
      checkLevelFired(p, firedButton);
      return;
    }
    if (p.name == "Shop") {
      checkShopFired(p, firedButton);
      return;
    }
    //if (p.name == "Settings") {
    //  //checkSettingsFired();
    //  return;
    //}
  }
}

//---------------------------------------------------------------
void checkLevelFired(GUIPage p, int firedButton) {
  //log.append("Interface2.checkLevelFired");
  println("max lvl = " + actualLevel);
  if (firedButton>maxReachedLvl)
    return;
  if (firedButton > 0) {
    lvls.lvlSelect = byte(firedButton);
    SetupSnake();
    GameStart = true;
  }
  if (firedButton == 0) {                                            //level->overview
    lvls.lvlSelect = -1;
    background(BackgroundColor);
    initButtonsStartScreen();
  }
  p.active = false;
}

void checkShopFired(GUIPage p, int firedButton) {
  //log.append("Interface2.checkShopFired");
  if (firedButton == 0) {
    SnakeColorSelected--;
    if (SnakeColorSelected<0)
      SnakeColorSelected = SnakeColor.length-1;
    if (boughtItems[SnakeColorSelected] == true) {
      p.Buttons.get(2).text="Choose";
    } else {
      p.Buttons.get(2).text="Buy";
    }
    p.Buttons.get(2).DrawButton();
  } else if (p.Buttons.get(firedButton).text == "Next") {
    SnakeColorSelected++;
    if (SnakeColorSelected>=SnakeColor.length)
      SnakeColorSelected = 0;
    if (boughtItems[SnakeColorSelected] == true) {
      p.Buttons.get(2).text="Choose";
    } else {
      p.Buttons.get(2).text="Buy";
    }
    p.Buttons.get(2).DrawButton();
  } else if (p.Buttons.get(firedButton).text == "Buy") {
    buySkin();
  } else if (p.Buttons.get(firedButton).text == "Choose") {
    chooseSkin();
  } else if (p.Buttons.get(firedButton).text == "Return") {
    background(BackgroundColor);
    SnakeColorSelected = SnakeNormalColor;
    shopmenu = false;
    p.active = false;
    guiPages[0].active = true;
    initButtonsStartScreen();
  }
}


void shopMenu() {
  //log.append("Interface2.shopMenu");
  fill(BackgroundColor);
  rect(0, 0, dWidth, dHeight);
  initButtonsShopScreen();
  if (boughtItems[SnakeColorSelected] == true) {
    guiPages[2].Buttons.get(2).text = "choose";
    guiPages[2].Buttons.get(2).DrawButton();
  }
  SnakeNormalColor = SnakeColorSelected;
  drawShopTexts();
}

void drawShopTexts() {
  //log.append("Interface2.drawShopTexts");
  fill(255);
  triangle(dWidth/10, 500, 2*dWidth/10, 520, 2*dWidth/10, 480);
  triangle(9*dWidth/10, 500, 8*dWidth/10, 520, 8*dWidth/10, 480);
  fill(#FFFBA2);
  text("Costs 5000 food", dWidth/2-150, 400);
  text(maxFood+" food", dWidth/10, 100);
}

void showSnake() {
  //log.append("Interface2.showSnake");
  float frequency = 2*PI/30;
  float offsetfrequency = (millis()*0.01)%(2*PI);
  int offsetx = dWidth/2-(60*5+31)/2;
  int offsety = 500;
  int size = 30;
  int stepsize = 5;
  int amplitude = 20;
  int NumberBody = 60;

  fill(255);
  noStroke();
  rect(offsetx-15, offsety-size/2-amplitude, 60*5+31, amplitude+2*size-10);
  stroke(0);
  for (int i=0; i<=NumberBody; i+=2) {
    float newRed =   (NumberBody-i)*red  (SnakeColor[SnakeColorSelected])/NumberBody;
    float newGreen = (NumberBody-i)*green(SnakeColor[SnakeColorSelected])/NumberBody;
    float newBlue =  (NumberBody-i)*blue (SnakeColor[SnakeColorSelected])/NumberBody;
    fill(color(newRed, newGreen, newBlue));
    ellipse(offsetx+i*stepsize, offsety+amplitude*math.sinS( i*frequency+offsetfrequency), size, size);
  }
}

void chooseSkin() {
  //log.append("Interface2.chooseSkin");
  SnakeNormalColor = SnakeColorSelected;
  boughtItems[SnakeColorSelected] = true;
  datahandler.savetoJson(getJsonPath());
}

void buySkin() {
  //log.append("Interface2.buySkin");
  if (maxFood>=5000) {
    maxFood-=5000;
    SnakeNormalColor = SnakeColorSelected;
    boughtItems[SnakeColorSelected] = true;
    datahandler.savetoJson(getJsonPath());
    shopMenu();
    guiPages[2].getButton("Buy").text = "Choose";
    guiPages[2].getButton("Choose").DrawButton();
  }
}
