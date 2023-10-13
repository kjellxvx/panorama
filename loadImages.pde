// define number of frames
int frames = 652;

int lenghtIntro1 = 20;
int lenghtIntro2 = 20;
int lenghtIntro3 = 20;

int startIntro1 = frames-lenghtIntro1-lenghtIntro2-lenghtIntro3;
int startIntro2 = frames-lenghtIntro1-lenghtIntro2;
int startIntro3 = frames-lenghtIntro1;

int EndIntro1 = frames-lenghtIntro2-lenghtIntro3;
int EndIntro2 = frames-lenghtIntro2;
int EndIntro3 = frames;

// for displaying the images
int numFrames = frames+1;  // The number of frames in the animation

int framesMain = frames-(lenghtIntro1+lenghtIntro2+lenghtIntro3); 
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
