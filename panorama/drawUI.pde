import controlP5.*;
ControlP5 cp5;

Slider closestValueSlider;
Slider roomDepthSlider;
CheckBox speedCheckbox;

int statsHeight = 200;
String selected = "none";
boolean useSpeed = false;

void initUi() {
  cp5 = new ControlP5(this);


  speedCheckbox = cp5.addCheckBox("checkBox")
    .setPosition(390, wH +80)
    .setSize(10, 10)
    .addItem("track speed", 0);

  speedCheckbox.setColorLabel(color(0)); // Set the text color to white


  // Setup sliders based on testMode
  if (testMode == true) {
    roomDepth = 4000;
    closestValueSlider = cp5.addSlider("closestValue")
      .setPosition(10, 600)
      .setSize(400, 20)
      .setRange(4000, minDepth) // Initially set a default range
      .setLabel("Closest Value");
  } else {
    roomDepthSlider = cp5.addSlider("roomDepth")
      .setPosition(10, 600)
      .setSize(wW-20, 20)
      .setRange(minDepth, 4000)
      .setLabel("Room Depth")
      .setValue(4000);
  }
}


void drawMenu() {
  cp5.draw();
  checkKeys();
  background(255);
  image(img, 0, 0);
  fill(0);
  textSize(50);
  text(closestValue, 20, wH + 45);
  textSize(20);
  text("presize", 20, wH + 65);
  fill(255, 0, 0);
  ellipse(closestX, closestY, 20, 20);
  textSize(50);
  text(average, 150, wH + 45);
  textSize(20);
  text("smooth", 150, wH + 65);
  fill(0, 0, 255);
  textSize(50);
  text(videoPos, 280, wH + 45);
  textSize(20);
  text("Frame", 280, wH + 65);
  fill(0, 255, 255);
  textSize(20);
  text(channel, 390, wH + 25);
  text("Channel", 435, wH + 25);
  text(pitch, 390, wH + 50);
  text("Pitch", 435, wH + 50);
  text(velocity, 390, wH + 75);
  text("Velocity", 435, wH + 75);

  fill(0, 0, 0);
  textSize(20);
  text("Animation:", 20, wH + 100);

  if (main && !nearStart && !nearEnd) {
    text("Main", 120, wH + 100);
  } else if (!main && !nearStart) {
    text("Intro", 120, wH + 100);
    text(intros + 1, 170, wH + 100);
  } else if (nearStart) {
    text("Outro", 120, wH + 100);
  }

  if (isMoving) {
    fill(0, 255, 0);
    text("Moving", 20, wH + 120);
  } else {
    fill(255, 0, 0);
    text("Still", 20, wH + 120);
  }

  stroke(0);
  fill(255, 0, 0);
  textSize(20);
  if (nearStart == true) {
    text("User very close", 300, 530);
  }
  if (nearEnd == true) {
    text("User leaving", 300, 530);
  }


  if (testMode== true) {
    strokeWeight(1);
    stroke(255, 0, 0);
    line(10, 580, 10, 600);
    fill(255, 0, 0);
    textSize(20);
    text("Intros", 20, 595);
    //line(150, 580, 150, 600);
    text("Main", 155, 595);
    //line(405, 580, 405, 600);
    text("Outro", 355, 595);
    line(409, 580, 409, 600);
  }

  stroke(0);
  strokeWeight(1);
  noFill();
  rect(xStart, yStart, xEnd - xStart, yEnd - yStart);
  fill(255, 255, 255, 200);
  noStroke();

  // Calculate the dimensions of the surrounding rectangles
  float leftRectWidth = xStart;
  float rightRectX = xEnd;
  float rightRectWidth = wW - xEnd;
  float topRectHeight = yStart;
  float bottomRectY = yEnd;
  float bottomRectHeight = wH - yEnd;

  // Draw rectangles to fill the space around the main rect
  rect(0, 0, leftRectWidth, wH);                // Left
  rect(rightRectX + 1, 0, rightRectWidth, wH);     // Right
  rect(leftRectWidth, 0, xEnd - xStart + 1, topRectHeight); // Top
  rect(leftRectWidth, bottomRectY + 1, xEnd - xStart + 1, bottomRectHeight); // Bottom





  stroke(255, 0, 0);
  strokeWeight(3);

  if (selected == "left") {
    line(xStart, yStart, xStart, yEnd);
  }

  if (selected == "right") {
    line(xEnd, yStart, xEnd, yEnd);
  }

  if (selected == "top") {
    line(xStart, yStart, xEnd, yStart);
  }

  if (selected == "bottom") {
    line(xStart, yEnd, xEnd, yEnd);
  }

  // draw direction arrows
  fill(255, 0, 0);
  noStroke();
  if (direction.equals("backwards")) {
    triangle(480, wH + statsHeight / 2, 490, wH + 50 + statsHeight / 2, 500, wH + statsHeight / 2);
    // triangle(480, 212, 490, 262, 500, 212);
  }
  if (direction.equals("forwards")) {
    triangle(480, wH + statsHeight / 2, 490, wH - 50 + statsHeight / 2, 500, wH + statsHeight / 2);
  }
}

void checkKeys() {
  if (keyz[0] == true) {
    println("save");
    saveValuesToFile();
  };

  if (keyz[1] == true) {
    selected = "left";
    if (keyz[5] == true) {
      xStart = xStart - 2;
    } else if (keyz[6] == true) {
      xStart = xStart + 2;
    }
  } else if (keyz[2] == true) {
    selected = "right";
    if (keyz[5] == true) {
      xEnd = xEnd - 2;
    } else if (keyz[6] == true) {
      xEnd = xEnd + 2;
    }
  } else if (keyz[3] == true) {
    selected = "top";
    if (keyz[7] == true) {
      yStart = yStart - 2;
    } else if (keyz[8] == true) {
      yStart = yStart + 2;
    }
  } else if (keyz[4] == true) {
    selected = "bottom";
    if (keyz[7] == true) {
      yEnd = yEnd - 2;
    } else if (keyz[8] == true) {
      yEnd = yEnd + 2;
    }
  } else {
    selected = "none";
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom("roomDepth")) {
    roomDepth = int(theEvent.getController().getValue());
  }
  if (theEvent.isFrom("closestValue")) {
    closestValue = int(theEvent.getController().getValue());
    calculateSpeed();
  }
  if (theEvent.isFrom("checkBox")) {
    useSpeed = speedCheckbox.getState(0);
  }
}
