import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
import org.openkinect.tests.*;

import processing.video.*;

Kinect2 kinect2;

JumpBox[][] boxList;
color[][] colorList;

int cellSize= 6;

int cols;
int rows;
float rotateAmountX = 0;
float rotateAmountY = 0;

int[] depth;

Capture ourVideo;

PImage kinectVideo;

int imgWidth = 512;
int imgHeight = 424;

PeasyCam camera;

int CameraX = 0, CameraY = 0;

boolean rotate = true;
float rotationY = 0;

PImage[] imageList = new PImage[0];

int minDepth =  100;
int maxDepth =  3000;

void setup() {
  size(1424, 948, P3D);              // must use P3D for any 3D stuff
  //fullScreen(P3D);

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initVideo();
  kinect2.initRegistered();
  kinect2.initDevice();

  //ourVideo = new Capture(this, width, height);
  //ourVideo.start();

  noStroke();
  cols = imgWidth/cellSize + 1;
  rows = imgHeight/cellSize + 1;
  boxList = new JumpBox[cols][rows];
  colorList = new color[cols][rows];
  imageList = (PImage[]) append(imageList, addImage("http://itp.nyu.edu/shows/spring2016/files/2016/03/SpringShowPoster_Final_1421.jpg"));
  imageList = (PImage[]) append(imageList, addImage("newyork.jpg"));
  imageList = (PImage[]) append(imageList, addImage("nature.jpg"));
  imageList = (PImage[]) append(imageList, addImage("tiger.jpg"));
  imageList = (PImage[]) append(imageList, addImage("http://maxmadesign.com/images/works/040-ITP%20video-02.jpg"));
  
  
  for (int x = 0; x < imgWidth; x+=cellSize) {
    for (int y = 0; y < imgHeight; y+=cellSize) {
      ArrayList colArray = new ArrayList();
      for(int i = 0; i < imageList.length; i++){
       colArray.add(imageList[i].get(x,y));
      }
      boxList[x/cellSize][y/cellSize] = new JumpBox((x*2)-(imgWidth), (y*2)-(imgHeight), (cellSize-1), colArray);
      
      
      boxList[x/cellSize][y/cellSize].setRGBSide("Back", 255, 255, 255);
      boxList[x/cellSize][y/cellSize].setRGBSide("Top", 255, 255, 255);
      boxList[x/cellSize][y/cellSize].setRGBSide("Bottom", 255, 255, 255);
      boxList[x/cellSize][y/cellSize].setRGBSide("Right", 255, 255, 255);
      boxList[x/cellSize][y/cellSize].setRGBSide("Left", 255, 255, 255);
      //boxList[x/cellSize][y/cellSize].setZ(0);
    }
  }
}

PImage addImage(String path){
  PImage img = loadImage(path);
  img.resize(imgWidth,imgHeight);
  return img;
}

void draw() {
  kinectVideo = kinect2.getRegisteredImage();
  lights();                         // we want the 3D to be shaded
  //ortho();
  background (0);
  kinectVideo.loadPixels();
  depth = kinect2.getRawDepth();
  translate(width/2, height/2, -200);
  rotateY(radians(CameraY));
  rotateX(radians(CameraX));
  if(rotate){
  rotationY = frameCount * 0.001f;
  }
  //rotateY(rotationY);
  for (int x = 0; x < imgWidth; x+=cellSize) {
    for (int y = 0; y < imgHeight; y+=cellSize) {

      PxPGetPixel(x, y, kinectVideo.pixels, imgWidth);
      if (depth[x+y*kinect2.depthWidth] > 0) {
        boxList[x/cellSize][y/cellSize].setZ(map(depth[x+y*kinect2.depthWidth], minDepth, maxDepth, 400, 0));
      }else{
        boxList[x/cellSize][y/cellSize].setZ(0);
      }
      boxList[x/cellSize][y/cellSize].update();
    }
  }
}

void mousePressed(){
  PImage realImage = kinect2.getVideoImage();
  for (int x = 0; x < imgWidth; x+=cellSize) {
    for (int y = 0; y < imgHeight; y+=cellSize) {
      boxList[x/cellSize][y/cellSize].addImage(realImage.get(x*(1920/512),y*(1080/424)));
    }
  }
  println("Picture added");
}

void keyPressed() {
  if (key == CODED) {
    //
    if (keyCode == UP) {
      CameraX+=10;
      // println("UP");
    } else if (keyCode == DOWN) {
      CameraX-=10;
    } else if (keyCode == RIGHT) {
      CameraY+=10;
    } else if (keyCode == LEFT) {
      CameraY-=10;
    } else {
      // nothing
    }
  } else { 
    // not key == CODED
    //
  }
  if (key == 'a') {
    minDepth = constrain(minDepth+100, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-100, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+100, minDepth, 1165952918);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-100, minDepth, 1165952918);
  }
  println("Min: " + minDepth + " Max: " + maxDepth);
}



int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}