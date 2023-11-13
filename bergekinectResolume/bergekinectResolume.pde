//########################################################################
//########################################################################
//########################################################################
//########################################################################

boolean testMode = true;

//########################################################################
//########################################################################
//########################################################################
//########################################################################


boolean keyz[] = new boolean[9];
int wW = 512;
int wH = 424;
int current = 0;
int intros = 0;
boolean main = true;
boolean finishIntro = false;

PImage img;

int closestValue;
float closestX;
int closestY;

// Define area
int xStart;
int xEnd;
int yStart;
int yEnd;

int videoPos;
int sound;

// For idle mode
boolean nearEnd = false;
boolean nearStart = false;
boolean introAnimation = false;
float position=0;

// Define room Depth
int roomDepth;
int maxDepth = 8000;
int minDepth= 497;

// For smoothing the values
int numReadings = 10;
int[] readings = new int[numReadings];
int readIndex = 0;              // the index of the current reading
int total = 0;                  // the running total
int average = 0;                // the average

// For checking direction the user is moving
int prevValue = 0;

// Boolean and string for direction
String direction = "idle";
int threshold = 5 ;

void setup() {

  loadSettings();
  initKinect();
  initOsc();
  initMidi();
  initUi();

  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  size(512, 424 + 200);
  frameRate(30);
  current = frames-idleFrames;

  /*
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
   readings[thisReading] = 0;
   }*/
}

void draw() {
  img.loadPixels();
  drawMenu();

  if (!testMode) {
    getDepth();
  }

  img.updatePixels();
  smooth(closestValue);

  if (average >= minDepth) {
    if (average > roomDepth) {
      videoPos = 0;
      sound = 0;
      mb.sendNoteOn(channel, pitch, sound);
    } else {
      videoPos = int(map(average, roomDepth, minDepth, 0, frames));
      triggerNote();
      checkDirection(average);
    }
  }

  if (videoPos >= frames - idleFrames) {
    nearStart = true;
  } else if (videoPos <= frames - idleFrames) {
    nearStart = false;
  }

  if (videoPos <= introLength) {
    nearEnd = true;
  } else if (videoPos >= introLength) {
    nearEnd = false;
  }

  if (videoPos > 1 && main && !nearStart) {
    finishIntro = false;
    sendOsc(videoPos);
  } else {
    if (nearStart) {
      float zigZag = idle(idleSpeed, frames - idleFrames, frames);
      videoPos = int(zigZag);
      sendOsc(int(zigZag));
    }
  }

  if (nearEnd || finishIntro) {
    main = false;
    finishIntro = true;
    if (intros == 0) {
      current = count(current, startIntro1, EndIntro1);
      videoPos = current;
    }
    if (intros == 1) {
      current = count(current, startIntro2, EndIntro2);
      videoPos = current;
    }

    if (intros == 2) {
      current = count(current, startIntro3, EndIntro3);
      videoPos = current;
    }
    if (intros == 3) {
      current = count(current, startIntro4, EndIntro4);
      videoPos = current;
    }
    if (intros == 4) {
      current = count(current, startIntro5, EndIntro5);
      videoPos = current;
    }

    sendOsc(current);
    if (current == EndIntro1 || current == EndIntro2 || current == EndIntro3 || current == EndIntro4 || current == EndIntro5) {
      main = true;
      int[] introArray = {0, 1, 0, 2, 0, 3, 0, 4};
      int randomIndex = int(random(0, introArray.length));
      intros = introArray[randomIndex];
    }
  }
}


int count(int current, int start, int end) {
  current = (current - start + 1) % (end - start + 1) + start;
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
