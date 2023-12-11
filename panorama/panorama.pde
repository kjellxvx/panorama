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
boolean nearStartActivated = false;
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
int threshold = 1 ;

boolean isMoving = true;
int prevValueForMovementCheck;
int thresholdForMovementCheck = 2;
int lastUpdateTime;

void setup() {

  loadSettings();
  initKinect();
  initOsc();
  initMidi();
  initUi();

  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  size(512, 424 + 200);
  frameRate(12);
  current = frames-idleFrames;

  /*
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
   readings[thisReading] = 0;
   }*/
}

void draw() {
  updateImage();
  if (!testMode) {
    getDepth();
  }
  processDepthData();
  updateVideoPositionBasedOnDepth();
  checkIdleAndIntroStates();
  sendOscillationCommands();
}

void updateImage() {
  img.loadPixels();
  drawMenu();
  img.updatePixels();
}

void processDepthData() {
  smooth(closestValue);
  videoPos = int(map(average, roomDepth, minDepth, introLength, frames-idleFrames));
  checkDirection(average);
  detectMovement(average);
}

void updateVideoPositionBasedOnDepth() {
  // Check if the user has activated nearStart mode
  if (nearStartActivated) {
    // If nearStart mode is activated, stay in nearStart mode regardless of videoPos
    main = false;
    nearEnd = false;
    nearStart = true;

    // Check if the user has moved to the range of 1350 to 1360
    if (average >= 500 && average < 1000) {
      // Disable nearStart mode if the user is in the specified range
      nearStartActivated = false;
    }
  } else {
    // Reset all states
    main = false;
    nearEnd = false;
    nearStart = false;

    // Check if videoPos is within the nearStart range
    if (average >= 4000) {
      // When the video position is near the end (i.e., in the intro frames)
      nearEnd = true;
    } else if (average <= 600) {
      // When the video position is near the start (i.e., in the idle frames)
      nearStart = true;
      nearStartActivated = true;  // Activate nearStart mode
    } else {
      // In all other cases, we are in the main part of the video
      main = true;
    }
  }
}


void checkIdleAndIntroStates() {
  if (videoPos > 1 && main && !nearStart) {
    finishIntro = false;
  } else if (nearStart) {
    idleFunction();
  }

  if (nearEnd || finishIntro) {
    handleIntroAnimation();
  }
}

void idleFunction() {
  direction = "forwards";
  current = count(current, frames - idleFrames + 1, frames);
  videoPos = int(current);
}

void handleIntroAnimation() {
  if (nearEnd) {
    intros = updateIntroSequence(intros);
    videoPos = current;
    main = false;
  }
}

int updateIntroSequence(int introStage) {
  direction = "forwards";
  int[] introPoints = new int[]{startIntro1, EndIntro1, startIntro2, EndIntro2, startIntro3, EndIntro3, startIntro4, EndIntro4, startIntro5, EndIntro5};
  current = count(current, introPoints[introStage * 2], introPoints[introStage * 2 + 1]);

  if (current == introPoints[introStage * 2 + 1]) {
    main = true;
    int[] introArray = {0, 1, 0, 2, 0, 3, 0, 4};
    int randomIndex = int(random(0, introArray.length));
    return introArray[randomIndex];
  }
  return introStage;
}

void sendOscillationCommands() {
  sendOsc(videoPos);
  triggerNote();

  if (!isMoving) {
    abortNote();
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
  if (average > 4000) {
    average = 4000;
  }
}


void checkDirection(int currentValue) {
  if (abs(currentValue - prevValue) > threshold) {
    if (currentValue > prevValue) {
      direction = "backwards";
    } else {
      direction = "forwards";
    }
  } else {
    direction = "idle";
  }
  prevValue = currentValue;
}

void detectMovement(int currentValue) {
  int currentTime = millis();
  if (main) {
    if (currentTime - lastUpdateTime >= 200) { // Check if 0.5 second has elapsed
      if (abs(currentValue - prevValueForMovementCheck) <= thresholdForMovementCheck) {
        isMoving = false;
      } else {
        isMoving = true;
      }
      prevValueForMovementCheck = currentValue;
      lastUpdateTime = currentTime;
    }
  } else {
    isMoving = true;
  }
}
