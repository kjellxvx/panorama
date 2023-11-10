import controlP5.*;
ControlP5 cp5;

Slider closestValueSlider;
Slider roomDepthSlider;

int statsHeight = 200;
String selected = "none";

void initUi() {
  cp5 = new ControlP5(this);
  // Setup sliders based on testMode
  if (testMode == true) {
    roomDepth = 4000;
    closestValueSlider = cp5.addSlider("closestValue")
      .setPosition(10, 600)
      .setSize(400, 20)
      .setRange(minDepth, 4000) // Initially set a default range
      .setLabel("Closest Value");
  } else {
    roomDepthSlider = cp5.addSlider("roomDepth")
      .setPosition(10, 600)
      .setSize(400, 20)
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
  textSize(50);
  text(sound, 410, wH + 45);
  textSize(20);
  text("MIDI", 410, wH + 65);


  fill(0, 0, 0);
  textSize(20);
  text("Animation:", 20, wH + 100);
  if (main == false ) {
    if (nearStart == false) {
      text("Intro", 120, wH + 100);
      text(intros+1, 170, wH + 100);
    }
  }
  if (nearStart == true) {
    text("Outro", 120, wH + 100);
  }
  if (main == true ) {
    text("Main", 120, wH + 100);
  }
  stroke(0);
  fill(255, 0, 0);
  textSize(20);
  if (nearStart == true) {
    text("nearStart", 400, 530);
  }
  if (nearEnd == true) {
    text("nearEnd", 400, 530);
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

  stroke(0, 0, 255);
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
  if (direction.equals("forwards")) {
    triangle(480, wH + statsHeight / 2, 490, wH + 50 + statsHeight / 2, 500, wH + statsHeight / 2);
    // triangle(480, 212, 490, 262, 500, 212);
  }
  if (direction.equals("backwards")) {
    triangle(480, wH + statsHeight / 2, 490, wH - 50 + statsHeight / 2, 500, wH + statsHeight / 2);
  }
}

void checkKeys() {
  if (keyz[0] == true) {
    println("save");
    saveValuesToFile();
    menu = !menu;
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
  }
}
