int cellSize= 30;                  // the size of each element

int clickRotation = 0;

int opacity = 255;

void setup() {
 size(1000, 800,P3D);              // must use P3D for any 3D stuff
 //fullScreen(P3D);
 noStroke();
}

void draw() {
 lights();                         // we want the 3D to be shaded
 ortho();
 background (0);
 for (int x = 0; x < width; x+=cellSize) {
   for (int y = 0; y < height; y+=cellSize) {
     float distanceToMouse= dist(x, y, mouseX, mouseY);     // calculate the distance of the element to the mouse
     float rotation = 0;
     if(distanceToMouse < 90){
       rotation = distanceToMouse;
     }
     pushMatrix();        // if we dont push and pop the matrix our transformations will accumolate
     translate(x, y);
     rotateX(radians(abs(distanceToMouse)) + (frameCount * 0.05));
     rotateY(radians(abs(distanceToMouse)) + (frameCount * 0.05));
     if(distanceToMouse < 360){
       //rotateX(radians(abs(distanceToMouse)));
       //rotateX(frameCount * 0.001);
       //translate(0,0, distanceToMouse);
     }else{
       //rotateX(frameCount * 0.01);
       //rotateY(frameCount * 0.02);
     }
     rotateX(clickRotation);
     drawBox();
     //rotateX(abs(distanceToMouse));
     //rotateX(0);                      
     //pushStyle();
     //fill(255, 0, 0);
     //rect(0,0,cellSize,cellSize);
     //popStyle();
     //pushStyle();
     //fill(0, 255, 0);
     //rotateX(180);
     //rect(0,0,cellSize,cellSize);
     //popStyle();
     //pushStyle();
     //fill(0, 0, 255);
     //rotateX(360);
     //rect(0,0,cellSize,cellSize);
     //popStyle();
     popMatrix();
   }
 }
}

void mouseClicked() {
  clickRotation += 90;
}

void drawBox(){
  scale(10);
  // Front
  beginShape(QUADS);
  fill(255,0,0, opacity);
  vertex(-1, -1,  1);
  vertex( 1, -1,  1);
  vertex( 1,  1,  1);
  vertex(-1,  1,  1);
  endShape();
  // Back
  beginShape(QUADS);
  fill(255,255,0, opacity);
  vertex( 1, -1, -1);
  vertex(-1, -1, -1);
  vertex(-1,  1, -1);
  vertex( 1,  1, -1);
  endShape();
  // Bottom
  beginShape(QUADS);
  fill( 255,0,255, opacity);
  vertex(-1,  1,  1);
  vertex( 1,  1,  1);
  vertex( 1,  1, -1);
  vertex(-1,  1, -1);
  endShape();
  // Top
  beginShape(QUADS);
  fill(0,255,0, opacity);
  vertex(-1, -1, -1);
  vertex( 1, -1, -1);
  vertex( 1, -1,  1);
  vertex(-1, -1,  1);
  endShape();
  // Right
  beginShape(QUADS);
  fill(0,0,255, opacity);
  vertex( 1, -1,  1);
  vertex( 1, -1, -1);
  vertex( 1,  1, -1);
  vertex( 1,  1,  1);
  endShape();
  // Left
  beginShape(QUADS);
  fill(0,255,255, opacity);
  vertex(-1, -1, -1);
  vertex(-1, -1,  1);
  vertex(-1,  1,  1);
  vertex(-1,  1, -1);
  endShape();
}