class Math {
  float[] sinAngle = new float[360];
  float[] cosAngle = new float[360];
  Math() {
    initTrig();
  }

  /***************************************
   *Calculates between mouse and Snakehead
   ***************************************/
  float Anglecalc(int x, int y, int x2, int y2) {    //Angle between mouse and Snake
    float Angle = atan2(y2-y, x2-x)+PI;
    return Angle;
  }
  float Anglecalc(float x, float y, float x2, float y2) {    //Angle between mouse and Snake
    float Angle = atan2(y2-y, x2-x)+PI;
    return Angle;
  }
  float Anglecalc(int x, int y, float x2, float y2) {    //Angle between mouse and Snake
    float Angle = atan2(y2-y, x2-x)+PI;
    return Angle;
  }
  float Anglecalc(float x, float y, int x2, int y2) {    //Angle between mouse and Snake
    float Angle = atan2(y2-y, x2-x)+PI;
    return Angle;
  }

  Boolean[] setvalBool(Boolean[] Arr) {
    for (int i=0; i<Arr.length; i++)
      Arr[i] = false;
    return Arr;
  }

  //Muss noch getestet werden
  Object[] setObj(Object[] Obj) {
    for (int i=0; i<Obj.length; i++)
      Obj[i] = new Object();
    return Obj;
  }

  Boolean checkBoundaries (int x, int y, int size) {
    //log.append("math.checkBoundaries");
    if (x-size<snake[activeSnake].body.get(0).pos.x-dWidth/4)
      return false;
    else if (x+size>snake[activeSnake].body.get(0).pos.x+dWidth/4)
      return false;
    else if (y-size<snake[activeSnake].body.get(0).pos.y-dHeight/NumberPlayer)
      return false;
    else if (y+size>snake[activeSnake].body.get(0).pos.y+dHeight/NumberPlayer)
      return false;
    return true;
  }
  float sinS(float Angle) {
    int DAngle = round(Angle*360/(2*PI));
    while (DAngle < 0 || DAngle >= 360) {
      if (DAngle >=360)
        DAngle = DAngle -360;
      else if (DAngle <0)
        DAngle = DAngle + 360;
    }
    float SAngle = sinAngle[DAngle];
    return SAngle;
  }
  float cosS(float Angle) {
    int DAngle = round(Angle*360/(2*PI));
    while (DAngle < 0 || DAngle >= 360) {
      if (DAngle >=360)
        DAngle = DAngle -360;
      else if (DAngle <0)
        DAngle = DAngle + 360;
    }
    float SAngle = cosAngle[DAngle];
    return SAngle;
  }

  void initTrig() {
    //log.append("math.initTrig");
    for (int Angle = 0; Angle<360; Angle++) {
      sinAngle[Angle] = sin(2*PI*Angle/360);
      cosAngle[Angle] = cos(2*PI*Angle/360);
    }
    sinAngle[0] = 0;
    sinAngle[180] = 0;
    cosAngle[90] = 0;
    cosAngle[270] = 0;
  }

  float AngleResize(float Angle, float oldAngle) {
    //log.append("math.AngleResize");
    float Anglediff = min((2 * PI) - abs(Angle - oldAngle), abs(Angle - oldAngle));
    float maxAngle = PI/15;
    if (Anglediff > maxAngle) {
      if ((2 * PI) -abs(Angle - oldAngle) > abs(Angle - oldAngle)) {
        if (Angle-oldAngle > 0)
          Angle = oldAngle+maxAngle;
        else
          Angle = oldAngle-maxAngle;
      } else {
        if (Angle-oldAngle >0)
          Angle = oldAngle-maxAngle;
        else
          Angle = oldAngle+maxAngle;
      }
      if (Angle >=2*PI)
        Angle = Angle - 2*PI;
      else if (Angle<0)
        Angle = Angle+2*PI;
    }
    return Angle;
  }

  float cosAlike(float x) {
    float a=0.000124;
    float q = -a*90*90;
    x=x*180/PI;
    x+=180;
    if (x>270)
      x-=360;
    else if (x<-90)
      x+=360;
    if (x>=90) {
      a*=-1;
      q *= -1;
      x-=180;
    }
    float y= a*x*x+q;
    return y;
  }

  float sinAlike(float x) {
    return cosAlike(x-PI/2);
  }


  int[][] DashedLine(int x1, int y1, int x2, int y2) {
    //log.append("math.DashedLine");
    int spacing = 20;
    int linelength = 10;
    int[][] Dots = new int[ceil(dist(x1, y1, x2, y2)/(spacing+linelength))][4];
    int mulx = 1;
    int muly = 1;
    if ( x1 > x2) {
      mulx=-1;
    }
    if ( y1 > y2) {
      muly = -1;
    }
    int dx = mulx*abs(x1-x2);
    int dy = muly*abs(y1-y2);
    float distance = dist(x1, y1, x2, y2);
    float intersections = distance/(spacing+linelength);
    for (int i=0; i<intersections; i++) {
      float x0 = x1+(i/intersections)*dx;
      float y0 = y1+(i/intersections)*dy;
      if (dist(x0, y0, x2, y2) <= dist(x0, y0, x0+linelength*(dx/distance), y0+linelength*(dy/distance)))
        continue;
      pg_Lines.line(x0,
        y0,
        x0+(linelength*(dx/distance)),
        y0+(linelength*(dy/distance)));
    }
    return Dots;
  }
}

void circle(int x, int y, int size) {
  ellipse(x, y, size, size);
}

PImage[] picToFrames(String imagePath, int nrFrames) {
  PImage[] slices = new PImage[nrFrames];
  PImage mainPic = loadImage(imagePath);        //foodimages will be loaded once.
  mainPic.resize(mainPic.width,mainPic.height * 4);
  int w = mainPic.width / nrFrames;
  println(w);
  for (int i = 0; i < nrFrames; i ++) {
    int posX = round(float(i)/float(nrFrames) * mainPic.width);
    slices[i] = mainPic.get(posX, 0, w, mainPic.height );
  }
  return slices;
}
