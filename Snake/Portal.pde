class Portal{
  int[][] pos = new int[2][2];
  color colour1 = color(random(255),random(255),random(255));
  color colour2 = colour1;
  int size = 20;
  int id;
  
  Portal(){   
    pos[0][0] = int(random(width));
    pos[0][1] = int(random(height));
    pos[1][0] = int(random(width));
    pos[1][1] = int(random(height));
  }
  Portal(int[] posstart){   
    pos[0][0] = posstart[0];
    pos[0][1] = posstart[1];
    pos[1][0] = posstart[2];
    pos[1][1] = posstart[3];
  }
  
  
}
