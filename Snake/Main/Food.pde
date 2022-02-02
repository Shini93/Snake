/***********************************
 *Handles all about Food and upgrades
 ***********************************/
class Food {
  /*********************************
   *Public variables
   *********************************/
  int size;
  int id;
  int FoodKind;                  //0 = normal; 1 = big chunk; 2 = special gold
  int posx;
  int posy;
  int BGcolour;
  int colour = color(#FFFFFF);
  int value;                     //How much a snake grows when eating it

  /********************************
   *Overloaded constructor
   ********************************/
  Food(int aid, int foodkind) {
    id = aid;
    FoodKind = foodkind;
    posx = int(random(width));
    posy = int(random(height));
    init();
  }
  Food(int aid, int foodkind, int x, int y) {
    id = aid;
    FoodKind = foodkind;
    posx = x;
    posy = y;
    init();
  }
  
  /**************************************
  *resets the Food and respawns it
  **************************************/
  void reset() {
    posx = int(random(width));
    posy = int(random(height));
    FoodKind=round(random(11));
    if (FoodKind == 11)
      FoodKind = 2;
    else
      FoodKind = round(FoodKind/10);
    init();
  }
  
  /**************************************
  *defines the parameters
  **************************************/
  void init () {
    colour = color(#FFFFFF);
    if (FoodKind == 0) {
      size = 5;
      BGcolour = color(#00FF00);
      value = 1;
    } else if (FoodKind ==1) {
      size = 10;
      BGcolour = color(#0000FF);
      value = 5;
    } else {
      size = 15;
      BGcolour = color(#FFFF00);
      value = 100;
    }
  }
}
