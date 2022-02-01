/****************************
*Block class
*Blocks defined in lvl system
*****************************/
class Blocks{
  int[] pos = new int[2];    //x,y position
  color colour = 0;          //startcolor is black
  int size = 30;
  int id;
  
  Blocks(int ida, int x, int y){ //overloaded constructor
    pos[0] = x;
    pos[1] = y;
    id = ida;                //Block ID not implemented yet
  }
  
  Blocks(int ida){            //overloaded constructor
    id = ida;
  }
  
  void reset() {              //has to be changed to positions on the grid.
    pos[0] = int(random(width));
    pos[1] = int(random(height));
  }
}
