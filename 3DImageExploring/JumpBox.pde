class JumpBox {

  int x;
  int y;
  float z = 0;
  float goalZ = 0;
  int scale;
  int opacity = 255;
  float xRotation = 0;
  float yRotation = 0;
  float xRotationGoal = 0;
  float yRotationGoal = 0;

  float rotateAmount = 5;

  int red, green, blue;

  int topR, topG, topB;

  int rightR, rightG, rightB;

  int leftR, leftG, leftB;

  int bottomR, bottomG, bottomB;

  int backR, backG, backB;

  int depth = -80;
  
  //color[] colorArray;
  
  ArrayList colorArray;
  
  color currentColor = color(0,0,0);

  JumpBox(int posX, int posY, int scaleB, ArrayList _colorArray) {
    x = posX;
    y = posY;
    scale = scaleB;
    colorArray = _colorArray;
  }
  
  void addImage(color col){
    colorArray.add(col);
  }

  void update() {
    pushMatrix();

    if (z > goalZ && z>=1) {
      z -= 1;
    } else if (z < goalZ) {
      z = goalZ;
    }
    
    int arraySize = colorArray.size();
    if(arraySize > 0){
    
    for(int i = 0; i < arraySize; i++){
      if(z >= (400/arraySize)*(i) && z <= (400/arraySize)*(i+1)){
        currentColor = (color) colorArray.get(i);
      }
    }
    }
    
    
 

    translate(x, y, z);
    drawBox();
    popMatrix();
  }

  void rotateBox() {
    if (xRotationGoal < xRotation) {
      xRotation--;
    } else if (xRotationGoal > xRotation) {
      xRotation++;
    }
    if (yRotationGoal < yRotation) {
      yRotation--;
    } else if (yRotationGoal > yRotation) {
      yRotation++;
    }
  }

  void setZ(float _z) {
    goalZ = _z;
  }

  void setDepth(int _d) {
    depth = _d;
  }

  void setRGB(int r, int g, int b) {
    red = r;
    green = g;
    blue = b;
  }

  void setRGBSide(String side, int r, int g, int b) {
    if (side == "Top") {
      topR = r;
      topG = g;
      topB = b;
    } else if (side == "Bottom") {
      bottomR = r;
      bottomG = g;
      bottomB = b;
    } else if (side == "Right") {
      rightR = r;
      rightG = g;
      rightB = b;
    } else if (side == "Left") {
      leftR = r;
      leftG = g;
      leftB = b;
    } else if (side == "Back") {
      backR = r;
      backG = g;
      backB = b;
    }
  }

  void setRotateBox(int r, int g, int b) {
    red = r;
    green = g;
    blue = b;
    int highest = 1;
    if (r > highest) {
      highest = r;
    }
    if (g > highest) {
      highest = g;
    }
    if (b > highest) {
      highest = b;
    }
    float mappedR = map(r, 0, highest, 0, 45);
    float mappedG = map(g, 0, highest, 0, 45);
    float mappedB = map(b, 0, highest, 0, 45);
    xRotationGoal = (-45+(mappedR-mappedG));
    yRotationGoal = (-45+(mappedR-mappedB));
  }

  void reset() {
    xRotation = 200;
    yRotation = 200;
    rotateAmountX = 0;
    rotateAmountY = 0;
  }

  boolean overRect() {
    if (mouseX >= (this.x - scale) && mouseX <= (this.x - scale)+(scale*2) && 
      mouseY >= (this.y - scale) && mouseY <= (this.y - scale)+(scale*2)) {
      return true;
    } else {
      return false;
    }
  }

  void drawBox() {
    scale(scale);
    // Front
    beginShape(QUADS);
    //fill(red, green, blue, opacity);
    fill(currentColor);
    vertex(-1, -1, 1);
    vertex( 1, -1, 1);
    vertex( 1, 1, 1);
    vertex(-1, 1, 1);
    endShape();
    // Back
    beginShape(QUADS);
    fill(backR, backG, backB, opacity);
    vertex( 1, -1, depth);
    vertex(-1, -1, depth);
    vertex(-1, 1, depth);
    vertex( 1, 1, depth);
    endShape();
    // Bottom
    beginShape(QUADS);
    fill( bottomR, bottomG, bottomB, opacity);
    vertex(-1, 1, 1);
    vertex( 1, 1, 1);
    vertex( 1, 1, depth);
    vertex(-1, 1, depth);
    endShape();
    // Top
    beginShape(QUADS);
    fill(topR, topG, topB, opacity);
    vertex(-1, -1, depth);
    vertex( 1, -1, depth);
    vertex( 1, -1, 1);
    vertex(-1, -1, 1);
    endShape();
    // Right
    beginShape(QUADS);
    fill(rightR, rightG, rightB, opacity);
    vertex( 1, -1, 1);
    vertex( 1, -1, depth);
    vertex( 1, 1, depth);
    vertex( 1, 1, 1);
    endShape();
    // Left
    beginShape(QUADS);
    fill(leftR, leftG, leftB, opacity);
    vertex(-1, -1, depth);
    vertex(-1, -1, 1);
    vertex(-1, 1, 1);
    vertex(-1, 1, depth);
    endShape();
  }
}