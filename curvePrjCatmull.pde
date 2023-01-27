int numPoints = 24;
float [] Xp;
float [] Yp;
int offset = 10;
boolean curveToggle = false;
int frame = 500;
int count = 0;
int conCount = 0;
boolean control = false;
ArrayList points;
float minDistance = 20;
float xMax = 570;
float yMax = 375;
float xMin = 30;
float yMin = 25;

void setup() {
  size(600, 400);
  background(148, 39, 12);
  noFill();
  stroke(239, 210, 150);
  Xp = new float[numPoints];
  Yp = new float[numPoints];
  //randomSeed(10);
  points = new ArrayList();
  while (points.size() < numPoints) {
    PVector newPoint = new PVector(random(xMin, xMax), random(yMin, yMax));
    boolean isValid = true;
    for (int i = 0; i < points.size(); i++) {
      PVector oldPoint = (PVector) points.get(i);
      float distance = dist(newPoint.x, newPoint.y, oldPoint.x, oldPoint.y);
      if (distance < minDistance) {
        isValid = false;
        break;
      }
    }
    if (isValid) {
      points.add(newPoint);
    }
  }
  for(int i = 0; i<numPoints; i++) {
    PVector point = (PVector) points.get(i);
    Xp[i] = point.x;
    Yp[i] = point.y;
  }
}

void draw() {
  background(148, 39, 12);
  if(curveToggle) {
    catmullDraw();
  }else{
    bezierDraw();
  }  

}

boolean mouseClick() {
  for(int i = 0; i < numPoints; i ++) {
    if((mouseX <= Xp[i] +offset && mouseX >= Xp[i] -offset) && (
       (mouseY <= Yp[i] +offset && mouseY >= Yp[i] -offset))){
       println("true");
       return true;
       }
  }
  println("false");
  return false;
}    

int getI() {
  for(int i = 0; i < numPoints; i ++) {
    if((mouseX <= Xp[i] +10 && mouseX >= Xp[i] -10) && (
       (mouseY <= Yp[i] +10 && mouseY >= Yp[i] -10))){
       println(i);
       return i;
       }
  }
  println(-1);
  return (-1);
}    
void mouseDragged() {
  int i = getI();
   boolean inside = mouseClick();
  if(inside && i > 0) {
    Xp[i] += mouseX - pmouseX;
    Yp[i] += mouseY - pmouseY;
  }  
}

void mouseClicked() {
  offset += 600;
  if((mouseX > 0 && mouseX < 50) &&
     (mouseY > 0 && mouseY < 25)) count++;
  if((mouseX > 0 && mouseX < 50) &&
     (mouseY > 25 && mouseY < 50)) conCount++;
  if(   (count+1) % 2 == 0) curveToggle = true;
                     else curveToggle = false;
  if((conCount+1) % 2 == 0) control = true;
                   else control = false;
  println(mouseX);
  println(mouseY);
}

void mouseReleased() {
  offset = 10;
}

void catmullDraw() {
  fill(30, 130, 20);
  rect(0, 0, 50, 25);
  
  noFill();
  
  for (int i = 0; i < numPoints; i ++) {
  ellipse(Xp[i], Yp[i], 20, 20);
  }
  float tightness = map(sin(frameCount*.03)*(frameCount *0.5), -1, 1, -2, 5);
  //float tightness = 0;   // float = 0
  //float tightness = 1;
  curveTightness(tightness);
  beginShape();
  for (int i = 0; i < numPoints +3; i ++) {
    int j = i % numPoints;
    curveVertex(Xp[j], Yp[j]);
  }
  endShape();
}

void bezierDraw() {
  background(255);
  fill(0);
  rect(0, 0, 50, 25);
  rect(0, 25, 50, 25);
  noFill();
  for(int i = 4; i < numPoints; i+=4) {
    Xp[i] = Xp[i-1];
    Yp[i] = Yp[i-1];
    Xp[i+1] = Xp[i] + (Xp[i-1] - Xp[i-2]);
    Yp[i+1] = Yp[i] + (Yp[i-1] - Yp[i-2]);
    if((i+4) % numPoints == 0) {
      Xp[numPoints -1] = Xp[0];
      Yp[numPoints -1] = Yp[0];
      Xp[1] = Xp[0] + (Xp[numPoints-1] - Xp[numPoints-2]);
      Yp[1] = Yp[0] + (Yp[numPoints-1] - Yp[numPoints-2]);
    }
  }
  if(control) {
    drawControl();
    fill(30, 150, 20);
    rect(0, 25, 50, 25);
    noFill();
  }
  
  for(int i = 0; i < numPoints; i +=4) {
    bezier(Xp[i], Yp[i], Xp[i+1], Yp[i+1], Xp[i+2], Yp[i+2], Xp[i+3], Yp[i+3]);
}
stroke(234, 220, 150);
}

void drawControl() {
    for(int i = 0; i < numPoints; i ++) {
    int p0 = (i   ) % numPoints;
    int p1 = (i +1) % numPoints;
    int p2 = (i +2) % numPoints;
    int p3 = (i +3) % numPoints;
    
    ellipse(Xp[p0], Yp[p0], 20, 20);
    ellipse(Xp[p3], Yp[p3], 20, 20);
    
    stroke(255, 0, 0);
    
    line(Xp[p0], Yp[p0], Xp[p1], Yp[p1]);
    
    ellipse(Xp[p1], Yp[p1], 20, 20);
    
    stroke(0, 0, 255);
    ellipse(Xp[p2], Yp[p2], 20, 20);
      line(Xp[p3], Yp[p3], Xp[p2], Yp[p2]);
    stroke(0);
  }
}
