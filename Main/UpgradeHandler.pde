class UpgradeHandler{
  Boolean missile = false;
  Boolean miniSnake = false;
  Boolean speed = true;
  int glow = 100;       //glow radius
  int glowdistance = 100;
  Boolean[] PreUpgradeEaten = new Boolean[10];
  int[] PreUpgradePos = new int[10];
  float RayRadius = PI/16;
  int RayDistance = 200;
  int MaxSpecials = 0;
  int SpeedValue = 0;
  byte[] preUpdateCounter = new byte[10];      //counts the frames for the wanna be upgrade, until it becomes an upgrade
  int snakeID;
  UpgradeHandler(){
    PreUpgradeEaten = math.setvalBool(PreUpgradeEaten);
  } 
  
  void update(){      //TODO: counter that counts how many upgrades were added already
    for(int z = 0; z<10; z++){
      if(PreUpgradeEaten[z] == true){
        preUpdateCounter[z]++;
        if(preUpdateCounter[z]>3){
          preUpdateCounter[z] = 0;
          PreUpgradePos[z]++;
        }
        snake[snakeID].body.get(PreUpgradePos[z]).size = 10+2*preUpdateCounter[z];
        if(PreUpgradePos[z] == snake[snakeID].body.size()-1 && preUpdateCounter[z] == 3){
          int Specialvalue =  round(random(5.5));
          if(Specialvalue == 4 && RayRadius >=PI/4)
            while(Specialvalue != 4)
              Specialvalue =  round(random(5.5));
          specials.add(new Special(Specialvalue,snakeID));
          MaxSpecials++;
          PreUpgradeEaten[z] = false;
        }
      }
    }
  }
  
  void addUpgrade(int count){
    if(specials.get(count).Specialvalue ==0)
      missile = true;    //change so that it can have multiple rockets
    else if(specials.get(count).Specialvalue == 1){
      speed = true;      //change so that the speed can change too!
      SpeedValue += 0.1; 
    }
    else if(specials.get(count).Specialvalue == 2)
      miniSnake = true;  //change so that 1 or 2 can be added and distance can grow
    else if(specials.get(count).Specialvalue == 3){
      RayDistance+=50-50*(RayDistance/800);
      if(RayDistance > 480)
        RayDistance = 480;
    }
    else if(specials.get(count).Specialvalue == 4)
      RayRadius += PI/32;
    else if(specials.get(count).Specialvalue == 5){
      glow += glowdistance;
      //Set glow to Snake
      //expanse glow with each upgrade 
      //glow lights up parts where snake is
    }
  }
  
  //--------------------------------------------------------------------------------------------
  //Gets upgrade from shop and adds it to ingame
  float boughtUpgradeMultiplicator(int upgrade){
    switch(upgrade){
      //Speed
      case 0:
        return 1+boughtUpgrades[upgrade]*0.01;   //speed gets greater for 0.01 per lvl
      //Number Rockets
      case 1:
        return boughtUpgrades[upgrade];  //starting with 0 rockets, each upgrade adds 1 additional rocket
      //Number mini Snakes
      case 2:
        return boughtUpgrades[upgrade];  //starting with 0 additional mini snakes, each upgrade adds 1 mini snake
      //Faster movement of mini snakes
      case 3:
        return 1+ boughtUpgrades[upgrade] * 0.01;  //movement speed, amplitude and frequency of mini snakes speed
      //speed of updates to process from eating to updates to eat
      case 4:
        int x = boughtUpgrades[upgrade];
        return 0.005 * x * x - 0.2 * x + 3;  //starting with 3 frames per bodypart. Decreases by some amount per lvl max lvl 20 in this config
      //how far we can see
      case 5:
        return 1 + boughtUpgrades[upgrade] * 0.1; //seeing further with each upgrade about 0.1% per lvl
      //broader side
      case 6:
        return boughtUpgrades[upgrade] * (PI/90); //2 degree per lvl more to see
    }
    return 0.0;
  }

  void PreUpdate(){
    for(int i = 0; i<10;i++){
      if(PreUpgradeEaten[i]==false){
        PreUpgradeEaten[i] = true;
        PreUpgradePos[i] = 0;
        return;
      }
    }
  }
}
