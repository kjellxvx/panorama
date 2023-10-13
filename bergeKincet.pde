import org.openkinect.processing.*;
import themidibus.*;

Kinect2 kinect2;
MidiBus mb;

int channel = 1;
int pitch = 50;
int velocity = 0;

PApplet secondSketch;

int current = 0;
int intros = 0;
boolean main = true;
boolean finishIntro = false;

PImage img;

int closestValue;
float closestX;
int closestY;


// define area
int xStart;
int xEnd;
int yStart;
int yEnd;


int videoPos;
int sound;

// define blur kernel
float[][] kernel ={
  { 0.0625, 0.125, 0.0625},
  { 0.125, 0.25, 0.125},
  { 0.0625, 0.125, 0.0625},
};

// for idle mode
boolean nearEnd = false;
boolean nearStart = false;
boolean introAnimation = false;
float position=0;

int idleSpeed = 100;
int idleFrames = 20;

// define room Depth
int roomDepth = 4000;
int maxDepth = 8000;

boolean menu = true;

// for smoothing the values
int numReadings = 10;
int[] readings = new int[numReadings];
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

// for checking direction the user is moving
int prevValue = 0;

//boolean increasing = false;
String direction = "idle";
int threshold = 5 ;

void setup() {

  xStart = 200;
  xEnd = 512-100;
  yStart = 100;
  yEnd = 424-100;

  // initialize all the readings to 0:
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }

  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  // 512 x 424 pixels
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);

  //size(1920, 1080);
  //size(1680, 1050);
  fullScreen();
  //size(3840, 2160);
  frameRate(24);

  loadImages();

  MidiBus.list();
  mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
  mb.sendTimestamps(false);

  current = frames-idleFrames;

  secondSketch = new secondSketch();
  PApplet.runSketch(new String[]{"SecondSketch"}, secondSketch);
  secondSketch.loop(); // Start the second sketch
  secondSketch.getSurface().setLocation(0, 0);
}

void draw() {

  //background(0);
  img.loadPixels();
  getDepth();
  img.updatePixels();

  smooth(closestValue);

  // map the video position to the number of frames
  videoPos = int(map(average, 500, roomDepth, 0, numFramesMain-1));
  sound = int(map(average, 500, roomDepth, 0, 127));
  mb.sendNoteOn(channel, pitch, sound);

  checkDirection(average);
  //println(direction);

  // check if the user starts moving out of range
  // if user gets to close (between 600 and 500)
  if (average >= 500 && average<=600) {
    //println("moving towards the closest point!");
    nearStart = true;
    // only reset when the user acually moves back again
    // or out of frame, this still has to be coded!
  } else if (average >= 600 && average<=800) {
    nearStart = false;
  }

  // check if the user starts moving out of range
  // if user gets to far (between roomDepth-200 and 8000)
  if (average >= roomDepth-100 && average<=maxDepth && nearStart == false) {
    //println("moving out for range!");
    nearEnd = true;
  } else {
    nearEnd = false;
  }

  // NORMAL MODE when videoPos is between the max number of frames and not smaller then 1
  if (videoPos < numFramesMain && videoPos > 1 && main == true) {
    println("MAIN ANIMATION PLAYING");
    finishIntro = false;
    displayImage(videoPos, sound);
    // when the videoPos is bigger then the number of frames user it either to close or to far
  } else if (videoPos > numFramesMain || main == false) {
    // check if user is to far
    if (nearEnd == true || finishIntro == true) {
      main = false;
      finishIntro = true;
      // TOO FAR MODE

      if (intros == 0) {
        println("INTRO 1 PLAYING");
        current = count(current, startIntro1, EndIntro1);
      }

      if (intros == 1) {
        println("INTRO 2 PLAYING");
        current = count(current, startIntro2, EndIntro2);
      }

      if (intros == 2) {
        println("INTRO 3 PLAYING");
        current = count(current, startIntro3, EndIntro3);
      }

      displayImage(current, 0);

      if (current == EndIntro1 || current == EndIntro2 || current == EndIntro3) {
        main = true;
        //println("now a new animation could start");
        intros++;
        if (intros>=3) {
          intros=0;
        }
      }

      // check if user is to close
    } else if (nearStart == true) {
      // TOO CLOSE MODE
      println("TOO CLOSE ANIMATION PLAYING");
      main = true;
      float zigZag = idle(idleSpeed, 0, idleFrames);
      displayImage(int(zigZag), 0);
    }
    // if videoPos is not within range switch to idle to close, this happens sometimes when there is no value at all because the user is too close
  } else {
    if (nearStart == true) {
      // BACKUP TOO CLOSE MODE
      println("TOO CLOSE ANIMATION PLAYING");
      float zigZag = idle(idleSpeed, 0, idleFrames);
      displayImage(int(zigZag), 0);
    }
  }
}

int count (int current, int start, int end) {
  //println("current: " + current);
  if (current<end) {
    current++;
  } else {
    current = start;
  }
  return current;
}

// Smooth Function
void smooth(int sum) {
  // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = sum;
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;
}

// function to idle first and last few frames
float idle(int speed, int start, int end ) {
  position+=speed;
  float oscillation = (sin(position/100.0)+1)/2;
  float value = start + (end-start)*oscillation;
  //println(int(value));
  return int(value);
}

void checkDirection(int currentValue) {
  if (abs(currentValue - prevValue) > threshold) {
    if (currentValue > prevValue) {
      direction = "forwards";
    } else {
      direction = "backwards";
    }
  } else {
    direction = "idle";
  }
  prevValue = currentValue;
}

// display function
void displayImage(int videoPos, int sound) {
  background(0);
  image(images[frames-videoPos], 0, 0, width, height);
}

void keyPressed() {

  if (keyPressed) {
    if ( key == 'h') {
      if (menu) {
        secondSketch.noLoop(); // Start the second sketch
        secondSketch.getSurface().setVisible(false);
      } else {
        secondSketch.loop(); // Start the second sketch
        secondSketch.getSurface().setVisible(true);
      }
      menu = !menu;  // Toggle the state
    }
  }
}
