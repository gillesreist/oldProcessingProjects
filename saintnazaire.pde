import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import hypermedia.video.*;
import processing.video.*;
Movie side, toward, look, away;

PImage destination = createImage(1000,800, RGB);
PImage source = createImage(1000,800,RGB);

boolean clic=false;

int chrono = 0; //verifie si on parle
int chrono2 = 0; //verifie si personne ne parle
int timeRecord = 0;

Minim minim;
AudioInput in;
AudioRecorder recorder;

boolean sidecheck=true, towardcheck=false, lookcheck=false, awaycheck=false;

String nomAudio = "a";

int y = year();
int M = month();
int d = day();
int h = hour();
int m = minute();
int s = second();

//_______________________________________________________________________________________________________________________ creer un fichier son

void newFile()
{      
  y = year();
  M = month();
  d = day();
  h = hour();
  m = minute();
  s = second();
  nomAudio = nf(y, 4)+"."+nf(M, 2)+"."+nf(d, 2)+"."+nf(h, 2)+"."+nf(m, 2)+"."+nf(s, 2);
  recorder = minim.createRecorder(in, nomAudio + ".wav", true);
}

 //______________________________________________________________________________________________________________________ 

void setup() {
  size(displayWidth, displayHeight);
  frameRate(30);
  background(0);
  
  side = new Movie(this, "side.mp4");
  toward = new Movie(this, "toward.mp4");
  look = new Movie(this, "look.mp4");
  away = new Movie(this, "away.mp4");
  side.loop();
  
  minim = new Minim(this);
  in = minim.getLineIn();
}

 //______________________________________________________________________________________________________________________ si pas de micro on simule au clic

/*void mousePressed() { 
  if (clic==false) {
    clic=true;}
  else {
    clic=false;}
  chrono=0;
}*/

 //______________________________________________________________________________________________________________________ 

void draw() {
  
    
  int m = millis();
  
  int s = second();  //chrono
  if (timeRecord != s) {
    chrono ++;
    chrono2 ++;
    timeRecord ++;}
    
  if (timeRecord >59) {
    timeRecord = 0;
  }
  
  
//_________________________________________________________________________________________________________________  verification que quelqun parle
  
  
  float volume =  abs(in.left.get(2)*100);

//  println(" volume " + volume + " clic "+ clic + " chrono " + chrono + " chrono2 "+chrono2);
  
  
  if (volume > 5) {
    chrono2 = 0;
  }
  
  if ((volume < 5) && (chrono2 > 2)) {
    chrono = 0;}
    
  if (chrono > 8) {
    clic = true;
  }
  
  else {
    clic = false;
  }

//______________________________________________________________________________________________________________________  organisation des boucles videos et enregistrement audio
  
  if ((clic==true) && (sidecheck==true)) {
    side.stop();
    toward.jump(0);
    toward.play();
    sidecheck=false;
    towardcheck=true;
    newFile();
    recorder.beginRecord();
  }
  
  else if ((clic==false) && (lookcheck==true) && (chrono2 > 7)) {
    look.stop();
    away.jump(0);
    away.play();
    lookcheck=false;
    awaycheck=true;
    recorder.endRecord();
    recorder.save();
  }
  
  float md1 = toward.duration();
  float mt1 = toward.time();
  if ((md1 - mt1 < 0.1) && (towardcheck==true)) {
    toward.stop();
    look.loop();
    towardcheck=false;
    lookcheck=true;
  }
  
  float md2 = away.duration();
  float mt2 = away.time();
  if ((md2 - mt2 < 0.1) && (awaycheck==true)) {
    away.stop();
    side.loop();
    awaycheck=false;
    sidecheck=true;
  }

  
  
  if ((sidecheck==true) && (side.available())) {
    side.read();
    source=side.get( 0,0, 1000,800);
  }
  
  if ((towardcheck==true) && (toward.available())) {
    toward.read();
    source=toward.get( 0,0, 1000,800);
  }
  
  if ((lookcheck==true) && (look.available())) {
    look.read();
    source=look.get( 0,0, 1000,800);
  }
  
  if ((awaycheck==true) && (away.available())) {
    away.read();
    source=away.get( 0,0, 1000,800);
  }
  
 
 //______________________________________________________________________________________________________________________ deformation de limage parle son
  
 
  if (volume > 2) {
 
 float waveAmplitude =  in.left.get(2)*60, // pixels (taken from the audio volume)
       numWaves = 4;       // how many full wave cycles to run down the image
 source.loadPixels();
 destination.loadPixels();

 float yToPhase = 2*PI*numWaves / 800; // conversion factor from y values to radians.

 for(int x = 0; x < 1000; x++)
   for(int y = 0; y < 800; y++)
       {
         int newX, newY;
         newX = int(x + waveAmplitude*sin(y * yToPhase * m%1000));  // on peut supprimer le  * m%1000 pour avoir quelquechose de plus propre
         newY = y;
         color c;
         if(newX >= 1000 || newX < 0 ||
            newY >= 800 || newY < 0)
           c = color(0,0,0);
         else
           c = source.pixels[newY*1000 + newX];
         destination.pixels[y*1000+x] = c;}
         
  }
  
  else {
     for(int x = 0; x < 1000; x++)
       for(int y = 0; y < 800; y++)
         {color c;
         c = source.pixels[y*1000 + x];
         destination.pixels[y*1000+x] = c;}
  }

  
  
  image(destination, displayWidth/2-600, displayHeight/2-400);
  
   //______________________________________________________________________________________________________________________ problemes de memoire a vider
 
 g.removeCache(source); 
 g.removeCache(destination); 
 
  
}
