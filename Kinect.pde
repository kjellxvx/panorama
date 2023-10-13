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
        }
        // if not make the pixels white
      } else {
        img.pixels[y*kinect2.depthWidth + x] = color(255);
      }
    }
  }
}
