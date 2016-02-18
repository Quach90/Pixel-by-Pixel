JumpBox[][] boxList ;

int cellSize= 20;

int cols;
int rows;

void setup() {
  size(1000, 800, P3D);              // must use P3D for any 3D stuff
  noStroke();
  cols = width/cellSize + 1;
  rows = height/cellSize + 1;
  boxList = new JumpBox[cols][rows];
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {
      boxList[x/cellSize][y/cellSize] = new JumpBox(x, y, 9);
      //println(x + " " + x/30 + " " + y/30 + " " + y);
    }
  }
}
void draw() {
  lights();                         // we want the 3D to be shaded
  //perspective();
  background (0);
  //pushMatrix();
  //translate(width/2, height/2);
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {
      boxList[x/cellSize][y/cellSize].update();
    }
  }
  //popMatrix();

  //pushMatrix();
  //translate(width/2 + 20, height/2 + 20, 100);
  //drawBox();
  //popMatrix();
}

void mousePressed(){
  for (int x = 0; x < width; x+=cellSize) {
    for (int y = 0; y < height; y+=cellSize) {
      if(mouseButton == LEFT){
        boxList[x/cellSize][y/cellSize].flip(true);
      }else{
        boxList[x/cellSize][y/cellSize].flip(false);
      }
    }
  }
}

class JumpBox {

  int x;
  int y;
  float z = 0;
  int scale;
  int opacity = 255;
  float xRotation = 0;
  float yRotation = 0;
  float rotateAmount = 2;

  JumpBox(int posX, int posY, int scaleB) {
    x = posX;
    y = posY;
    scale = scaleB;
  }

  void update() {
    pushMatrix();
    
    if (overRect()) {
      z = 200;
      if (keyPressed == true) {
        if(keyCode == UP){
          xRotation += rotateAmount;
        }
        if(keyCode == DOWN){
          xRotation -= rotateAmount;
        }
        if(keyCode == RIGHT){
          yRotation += rotateAmount;
        }
        if(keyCode == LEFT){
          yRotation -= rotateAmount;
        }
      }
    } else if(z > 0) {
      z -= 0.5;
    }
    translate(x, y, z);
    rotateX(radians(xRotation));
    rotateY(radians(yRotation));
    drawBox();
    popMatrix();
  }
  
  void flip(boolean xFlip){
    if(xFlip){
      xRotation += 90;
    }else{
      yRotation += 90;
    }
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
    fill(255, 0, 0, opacity);
    vertex(-1, -1, 1);
    vertex( 1, -1, 1);
    vertex( 1, 1, 1);
    vertex(-1, 1, 1);
    endShape();
    // Back
    beginShape(QUADS);
    fill(255, 255, 0, opacity);
    vertex( 1, -1, -1);
    vertex(-1, -1, -1);
    vertex(-1, 1, -1);
    vertex( 1, 1, -1);
    endShape();
    // Bottom
    beginShape(QUADS);
    fill( 255, 0, 255, opacity);
    vertex(-1, 1, 1);
    vertex( 1, 1, 1);
    vertex( 1, 1, -1);
    vertex(-1, 1, -1);
    endShape();
    // Top
    beginShape(QUADS);
    fill(0, 255, 0, opacity);
    vertex(-1, -1, -1);
    vertex( 1, -1, -1);
    vertex( 1, -1, 1);
    vertex(-1, -1, 1);
    endShape();
    // Right
    beginShape(QUADS);
    fill(0, 0, 255, opacity);
    vertex( 1, -1, 1);
    vertex( 1, -1, -1);
    vertex( 1, 1, -1);
    vertex( 1, 1, 1);
    endShape();
    // Left
    beginShape(QUADS);
    fill(0, 255, 255, opacity);
    vertex(-1, -1, -1);
    vertex(-1, -1, 1);
    vertex(-1, 1, 1);
    vertex(-1, 1, -1);
    endShape();
  }
}