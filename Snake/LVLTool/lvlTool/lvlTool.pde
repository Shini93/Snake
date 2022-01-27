/***************
 *Global
 ***************/
ArrayList <Integer> blocksx = new ArrayList<Integer>();
ArrayList <Integer> blocksy = new ArrayList<Integer>();
int scale = 30;
boolean Mousepressed = false;
int timer = 0;
void setup() {
  size(800, 800);
  background(125);
}

void draw() {
  fill(125);
  rect(0, 0, 800, 800);
  fill(#FFFFFF);
  if (Mousepressed) {
    int xscaled = 0;
    int yscaled = mouseY;
    xscaled = round(mouseX/scale)*scale;
    yscaled = round(mouseY/scale)*scale;
    boolean exists = false;
    for (int i=blocksx.size()-1; i>=0; i--) {
      if (blocksx.size() > 0 && blocksx.get(i) == xscaled && blocksy.get(i) == yscaled) {
        exists = true;
        if (keyPressed && key=='d') {
          blocksx.remove(i);
          blocksy.remove(i);
        }
      }
    }
    if (exists == false && keyPressed==false) {
      blocksx.add(xscaled);
      blocksy.add(yscaled);
    }
  }
  for (int i=0; i<blocksx.size(); i++) {
    {
      rect(blocksx.get(i), blocksy.get(i), scale, scale);
    }
  }
  textSize(30);
  fill(0);
  text("P: print Blocks \nZ: undo Blocks \nR: reverse Blocks\nD+Click: delete hovered Block \nS: saves the blocks to a local file \nNumberBlocks: "+blocksx.size(), 0, 30);
}

void mousePressed() {
  Mousepressed = !Mousepressed;
}
void mouseReleased() {
  Mousepressed = !Mousepressed;
}
void keyPressed() {
  if (key =='p' || key == 'P') {
    print("\nx:\n"+blocksx);
    print("\ny:\n"+blocksy);
  } else if (key =='z' || key == 'Z') {
    blocksx.remove(blocksx.size()-1);
    blocksy.remove(blocksy.size()-1);
  } else if (key =='r' || key == 'R') {
    ArrayList <Integer> dummyX = new ArrayList<Integer>();
    ArrayList <Integer> dummyY = new ArrayList<Integer>();
    for (int i=0; i<width/scale+1; i++) {
      for (int k=0; k<height/scale+1; k++) {
        boolean exists = false;
        for (int j=0; j<blocksy.size(); j++) {
          if ( round((i)*scale) == blocksx.get(j) && round((k)*scale) == blocksy.get(j)) {
            exists = true;
          }
        }
        if (exists == false) {
          dummyX.add(round((i)*scale));
          dummyY.add(round((k)*scale));
        }
      }
    }
    blocksx = dummyX;
    blocksy = dummyY;
  } else if (key =='S' || key == 's') {
    PrintWriter output = createWriter("./data/Lvl.txt");
    String out = width+";\n"+height+"~";
    for(int i=0;i<blocksx.size();i++){
     out = out+blocksx.get(i)+";"+blocksy.get(i)+";\n";
    }
    
    
    output.write(out);
    output.flush();
    output.close();

    BufferedReader reader = createReader("Lvl.txt");
    String line = null;
    try {
      while ((line = reader.readLine()) != null) {
        String pieces = line;
        print(pieces);
      }
      reader.close();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
