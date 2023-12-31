import org.openkinect.processing.*;
Kinect2 kinect2;


float prevAverage = 0;
long prevTime = 0;
int speed = 0;
float maxAllowedSpeed = 0.5;

// Define blur kernel
float[][] kernel ={
  { 0.0625, 0.125, 0.0625},
  { 0.125, 0.25, 0.125},
  { 0.0625, 0.125, 0.0625},
};

void initKinect() {
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
}

void getDepth() {
  closestValue = maxDepth;
  int [] depth = kinect2.getRawDepth();
  for (int y = 1; y<kinect2.depthHeight-1; y++) {
    for (int x = 1; x<kinect2.depthWidth-1; x++) {
      int sum = 0; // Kernel sum for this pixel
      // in this nested loop the gaussion blur is applied to the depth data
      for (int kx = -1; kx <= 1; kx++) {
        for (int ky = -1; ky <= 1; ky++) {
          // Calculate the adjacent pixel for this kernel point
          int pos = (y + ky)*kinect2.depthWidth + (x + kx);
          int d = depth[pos];
          if (d<500) {
            sum = 4500;
          } else {
            sum += kernel[kx+1][ky+1] * d;
          }
        }
      }
      // map the depth value to brightness
      float b = map(sum, 0, 4500, 0, 255);
      float currentDepthValue = sum;
      // with the depth readings are between 0 and roomDepth draw every pixel with specific brightness
      if (currentDepthValue > 0 && currentDepthValue < roomDepth) {
        img.pixels[y*kinect2.depthWidth + x] = color(b);
        //calculate the current closest value
        if (currentDepthValue > 0 && currentDepthValue < closestValue && x>xStart && x<xEnd && y>yStart && y<yEnd) {
          closestValue = sum;
          closestX=x;
          closestY=y;
          calculateSpeed();
        }
        // if not make the pixels white
      } else {
        img.pixels[y*kinect2.depthWidth + x] = color(255);
      }
    }
  }
}


void calculateSpeed() {
  long currentTime = millis(); // Get the current time in milliseconds

  // Calculate the time difference
  long deltaTime = currentTime - prevTime;

  // Check if deltaTime is greater than 0 to avoid division by zero
  if (deltaTime > 0) {
    // Calculate the depth difference
    float depthDifference = abs(average - prevAverage);

    if (depthDifference >=1) {
      float rawSpeed = depthDifference / deltaTime;

      if (rawSpeed <= maxAllowedSpeed) {
        speed = round(map(rawSpeed, 0, maxAllowedSpeed, 0, 127));
      } else {
        speed = 127;
      }

      if (useSpeed) {
        velocity = speed;
        //println(speed);
      }
    }
  }

  // Update the previous values
  prevAverage = average;
  prevTime = currentTime;
}
