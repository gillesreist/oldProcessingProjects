import processing.serial.*;  //librairie pour lecture de la carte arduino
Serial myPort;

PFont myFont;

int detection;

boolean button1 = false;
boolean button2 = false;
boolean button3 = false;
boolean button4 = false;
boolean button5 = false;

boolean takePhoto = false;




import it.lilik.capturemjpeg.*;

private CaptureMJPEG cam;
PImage next_img = null;

int display_xsize = 800;  // display size
int display_ysize = 600;
int capture_xsize = 640;  // capture size
int capture_ysize = 480;

int[] R = new int[capture_xsize*capture_ysize];
int[] G = new int[capture_xsize*capture_ysize];
int[] B = new int[capture_xsize*capture_ysize];

String nomCliche = "a";

int y = year();
int M = month();
int d = day();
int h = hour();
int m = minute();
int s = second();




String adresse = "http://cam6284208.miemasu.net/nphMotionJpeg?Resolution=640x480&Quality=Clarity";
int buttonCheckSlow = 0;
int buttonCheck = 0; //verifie le bouton
int cameraCheck = 0; //pour faire concorder la capture

boolean showmymenu = true;
int longseconde = 25;

int secondes = 5;

int tempsDePause = 1; // en frame
int lastTime; // dernier temps sauvegardé

PImage timeIMG = createImage(capture_xsize, capture_ysize, RGB);

void setup() {
  // size(display_xsize, display_ysize);
  size(800, 600);
  noStroke();

  background(0);

  myPort = new Serial(this, Serial.list()[0], 9600);  //declarer l'objet de lecture arduino

  cam = new CaptureMJPEG (this, adresse);

  myFont = createFont("Verdana", 32);
  textFont(myFont);


  frameRate(25);
  lastTime = frameCount;

}

void draw() {



  while (myPort.available () > 0) {  //s'accorde sur la carte (difficulté a utiliser les variables définies par la carte hors du while)

    String arduino = myPort.readString();   //lecture de la carte
    arduino = trim(arduino);
    int detection = int(arduino);

    button1 = false;
    button2 = false;
    button3 = false;
    button4 = false;
    button5 = false;

    if (detection==1) {
      button1=true;
    }
    else if (detection==2) {
      button2=true;
    }
    else if (detection==3) {
      button3=true;
    }
    else if (detection==4) {
      button4=true;
    }
    else if (detection==5) {
      button5=true;
    }
  }








  if (buttonCheck == 1) {
    adresse = "http://cam6284208.miemasu.net/nphMotionJpeg?Resolution=640x480&Quality=Clarity";
  }
  else if (buttonCheck == 2) {
    adresse = "http://webcam.erieyachtclub.org/axis-cgi/mjpg/video.cgi";
  }
  else if (buttonCheck == 3) {
    adresse = "http://195.67.26.73/mjpg/video.mjpg";
  }
  else if (buttonCheck == 4) {
    adresse = "http://60.36.161.224:60016/-wvhttp-01-/getoneshot?camera_id=1&frame_count=no_limit";
  }
  else if (buttonCheck == 5) {
    adresse = "http://201.245.67.70/anony/mjpg.cgi";
  }

if (buttonCheckSlow >13){
  buttonCheckSlow = 13;
}

if (buttonCheckSlow <1){
  buttonCheckSlow = 1;
}





  if (lastTime != 0) {  //empeche la prise de photo avant de presser sur le bouton
    if ((frameCount - lastTime < tempsDePause) && (next_img != null)) {  //add les color et cache le bouton
      addColor();
    }

    for (int i = 0; i < timeIMG.pixels.length; i++) {
      int r = R[i]/tempsDePause;
      int g = G[i]/tempsDePause;
      int b = B[i]/tempsDePause;

      timeIMG.pixels[i] = color(r, g, b);
    }
    timeIMG.updatePixels();
  }


  image(timeIMG, (display_xsize-capture_xsize)/2, (display_ysize-capture_ysize)/2);
  //if (next_img != null) {
  //image(next_img, (display_xsize-capture_xsize)/2, (display_ysize-capture_ysize)/2);}



  //faire reapparaitre les boutons
  if (frameCount - lastTime >= tempsDePause + 25)  
  {
    showmymenu=true;
    
  }   

  //if ((frameCount - lastTime >= tempsDePause)  && (frameCount - lastTime <= tempsDePause+3))
  if (frameCount - lastTime == tempsDePause) {
    timeIMG.save(nomCliche+".jpg");
  }   


  if (showmymenu) {

    /////////////////// slider ////////////////
    fill(9, 41, 59);
    rect(20+(display_xsize-capture_xsize)/2, 20+(display_ysize-capture_ysize)/2, 598, 50);
    fill(20, 113, 161);
    rect(20+(display_xsize-capture_xsize)/2, 20+(display_ysize-capture_ysize)/2, longseconde*2, 50);
    if (longseconde<1) {
      longseconde=299;
    }
    if (longseconde>299) {
      longseconde=1;
    }
    secondes = longseconde / 5 + 1;
    textSize(25);
    fill(255);
    text(secondes, 220+(display_xsize-capture_xsize)/2, 55+(display_ysize-capture_ysize)/2);
    if (secondes==1) {
      text("SECONDE", 260+(display_xsize-capture_xsize)/2, 55+(display_ysize-capture_ysize)/2);
    }
    else {
      text("SECONDES", 260+(display_xsize-capture_xsize)/2, 55+(display_ysize-capture_ysize)/2);
    }

    ////////////////// camerabox //////////////////////////

    fill(9, 41, 59);
    rect(20+(display_xsize-capture_xsize)/2, 160, 70, 35);
    rect(20+(display_xsize-capture_xsize)/2, 220, 70, 35);
    rect(20+(display_xsize-capture_xsize)/2, 280, 70, 35);
    rect(20+(display_xsize-capture_xsize)/2, 340, 70, 35);
    rect(20+(display_xsize-capture_xsize)/2, 400, 70, 35);

    fill(80);
    rect(92+(display_xsize-capture_xsize)/2, 160, 70, 35);
    rect(92+(display_xsize-capture_xsize)/2, 220, 70, 35);
    rect(92+(display_xsize-capture_xsize)/2, 280, 70, 35);
    rect(92+(display_xsize-capture_xsize)/2, 340, 70, 35);
    rect(92+(display_xsize-capture_xsize)/2, 400, 70, 35);

    fill(255);
    textSize(12);
    text("CAMERA 1", 95+(display_xsize-capture_xsize)/2, 182);
    text("CAMERA 2", 95+(display_xsize-capture_xsize)/2, 242);
    text("CAMERA 3", 95+(display_xsize-capture_xsize)/2, 302);
    text("CAMERA 4", 95+(display_xsize-capture_xsize)/2, 362);    
    text("CAMERA 5", 95+(display_xsize-capture_xsize)/2, 422);

    if ((0 < buttonCheckSlow )& (buttonCheckSlow < 14 )) {
      fill(255);
      rect(20+(display_xsize-capture_xsize)/2, 160+60*(buttonCheck-1), 70, 35);
    }

    ////////////////////////////////////////////////////////////////////////:

    if (cameraCheck != buttonCheck) { //relancer la capture quand le menu est visible

      cam.stopCapture();
      cam = new CaptureMJPEG (this, adresse);
      cam.startCapture();
      cameraCheck = buttonCheck;
    }



    if (button1==true) {
      buttonCheckSlow-=1;
    }
    if (button2==true) {
      buttonCheckSlow+=1;
    }
    
    buttonCheck = buttonCheckSlow/3+1;
    
    if (button3==true) {
      longseconde = longseconde - 1;
    }
    if (button4==true) {
      longseconde = longseconde + 1;
    }

     if (button5==true) {
     takePhoto=true;
     }
     
  }
  
if (takePhoto)  {     //demarre la photo et change le nom du fichier
  if (buttonCheckSlow != 0) {
    tempsDePause = secondes*25;
    lastTime = frameCount;  //enregistre la valeur du framecount pour faire la difference
    showmymenu = false;
    y = year();
    M = month();
    d = day();
    h = hour();
    m = minute();
    s = second();
    nomCliche = nf(y, 4)+"."+nf(M, 2)+"."+nf(d, 2)+"."+nf(h, 2)+"."+nf(m, 2)+"."+nf(s, 2)+"."+nf(secondes, 2)+"."+nf(buttonCheck, 2, 0);
    takePhoto = false;
  }
}
  
}



void captureMJPEGEvent(PImage img) {
  next_img = img;
  next_img.resize(capture_xsize, capture_ysize);
}






//matrice pour ajouter les color
void addColor() {
  next_img.loadPixels();

  for (int i = 0; i < next_img.pixels.length; i++) {
    int r = (next_img.pixels[i] >> 16) & 0xFF;  // Faster way of getting red(argb)
    int g = (next_img.pixels[i] >> 8) & 0xFF;   // Faster way of getting green(argb)
    int b = next_img.pixels[i] & 0xFF; // Faster way of getting blue(argb)

    R[i] += r;
    G[i] += g;
    B[i] += b;

    //reset la photo
    if (frameCount - lastTime < 3) {
      R[i] = 0;
      G[i] = 0;
      B[i] = 0;
    }
  }
}



