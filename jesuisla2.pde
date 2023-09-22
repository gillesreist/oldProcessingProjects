public void init() { 
  frame.removeNotify(); 
  frame.setUndecorated(true); 
  frame.addNotify(); 
  super.init();
}

import SimpleOpenNI.*;
VideoBuffer monBuff;

int delay_time = 2;  // delay in seconds
int capture_frames = 25;  // capture frames per second
boolean flag;

SimpleOpenNI  context;

int timeRecord = 0;

void setup()
{
  context = new SimpleOpenNI(this);

  // mirror is by default enabled
  context.setMirror(true);
  
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
 
  size(1600, 600); 
  flag = false;


  monBuff = new VideoBuffer(delay_time*capture_frames, 800, 600);
  
  frameRate(capture_frames);
}


void draw()
{
   if (!flag) {
    frame.setLocation(0, 0);
    flag = true;
  }
  
  //chrono
  int sec =second();
  if (timeRecord != sec) {
    timeRecord ++;
  }

  if (timeRecord >59) {
    timeRecord = 0;
  }
  
  
  
  // update the cam
  context.update();
  
  background(0,0,0);
 
 PImage zImg = context.depthImage();
  int[] depthMap = context.depthMap();
  int s = depthMap.length;
  int nearLimit = 1000; //distance en mm
  int farLimit = 3500;

  zImg.loadPixels();
  
    for (int i=0;i<s;i++)
    {
      if (depthMap[i] < nearLimit || depthMap[i] > farLimit)
      //if(realWorldMap[i].y < nearLimit || realWorldMap[i].y > farLimit)
      {
        zImg.pixels[i] = color(0);
      }
      else
      {
        zImg.pixels[i] = color(255);
      }
    }
  
   zImg.updatePixels();
     
   zImg.resize(800,600);
   
  monBuff.addFrame( zImg );
   
   PImage bufimg = monBuff.getFrame();
   PImage tmpimg = createImage(bufimg.width,bufimg.height,RGB);
   tmpimg.copy(bufimg,0,0,bufimg.width,bufimg.height,0,0,bufimg.width,bufimg.height);
   
   
/*  PImage finalImg = createImage(640,480,RGB);
   zImg.loadPixels();
   tmpimg.loadPixels();
   finalImg.loadPixels();
  
  for (int i=0;i<s;i++)
    {
      if (zImg.pixels[i] == color(0) && tmpimg.pixels[i] == color(0))
      
      {
        finalImg.pixels[i] = color(0);
      }
      else
      {
        finalImg.pixels[i] = color(255);
      }
    }
    
   finalImg.updatePixels(); */
   
 
 
 
 
 image(zImg, 800, 0); 
 blend(tmpimg, 0, 0, 800, 600,800, 0, 800, 600, DARKEST);
 
 
/* if ((timeRecord%20==5)||(timeRecord%20==6)) {
  image(zImg, 0, 0); 
  tmpimg.filter(INVERT);
  blend(tmpimg, 0, 0, 800, 600, 0, 0, 800, 600, EXCLUSION);
 } */
 
    image (tmpimg, 0, 0);

 
    zImg.resize(640, 480);   
}




class VideoBuffer
{
 PImage[] buffer;
 
 int inputFrame = 0;
 int outputFrame = 0;
 int frameWidth = 0;
 int frameHeight = 0;

 /*
   parameters:

   frames - the number of frames in the buffer (fps * duration)
   width - the width of the video
   height - the height of the video
 */
  VideoBuffer( int frames, int width, int height )
 {
   buffer = new PImage[frames];
   for(int i = 0; i < frames; i++)
   {
     this.buffer[i] = new PImage(width, height);
   }
   this.inputFrame = frames - 1;
   this.outputFrame = 0;
   this.frameWidth = width;
   this.frameHeight = height;
 }



 // return the current "playback" frame.  
 PImage getFrame()
 {
   int frr;
   
   if(this.outputFrame>=this.buffer.length)
     frr = 0;
   else
     frr = this.outputFrame;
   return this.buffer[frr];
 } 
 
 
 // Add a new frame to the buffer.
 void addFrame( PImage frame )
 {
   // copy the new frame into the buffer.
   System.arraycopy(frame.pixels, 0, this.buffer[this.inputFrame].pixels, 0, this.frameWidth * this.frameHeight);
   
   
   //faire une boucle avec le buffer
  this.inputFrame = (this.inputFrame+1) % this.buffer.length;
  this.outputFrame = (this.outputFrame+1) % this.buffer.length;
  
  
 
 }
} 
