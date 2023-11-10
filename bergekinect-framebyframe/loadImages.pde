// define number of frames (number of files -1)
int frames = 1894;

int lenghtIntro1 = 120;
int lenghtIntro2 = 92;
int lenghtIntro3 = 93;
int lenghtIntro4 = 96;
int lenghtIntro5 = 99;

int startIntro1 = frames-lenghtIntro1-lenghtIntro2-lenghtIntro3-lenghtIntro4-lenghtIntro5;
int startIntro2 = frames-lenghtIntro1-lenghtIntro2-lenghtIntro3-lenghtIntro4;
int startIntro3 = frames-lenghtIntro1-lenghtIntro2-lenghtIntro3;
int startIntro4 = frames-lenghtIntro1-lenghtIntro2;
int startIntro5 = frames-lenghtIntro1;

int EndIntro1 = frames-lenghtIntro2-lenghtIntro3-lenghtIntro4-lenghtIntro5;
int EndIntro2 = frames-lenghtIntro2-lenghtIntro3-lenghtIntro4;
int EndIntro3 = frames-lenghtIntro2-lenghtIntro3;
int EndIntro4 = frames-lenghtIntro2;
int EndIntro5 = frames;

// for displaying the images
int numFrames = frames+1;  // The number of frames in the animation

int framesMain = frames-(lenghtIntro1+lenghtIntro2+lenghtIntro3-lenghtIntro4-lenghtIntro5); 
int numFramesMain = framesMain+1;  // The number of frames in the animation

int currentFrame = 0;
PImage[] images = new PImage[numFrames];

void loadImages() {
  for (int i = 0; i < numFrames; i++) {
    String imageName = "Anna_HD_" + nf(i, 5) + ".jpg";
    images[i] = loadImage(imageName);
    println("image" + i);
  }
}
