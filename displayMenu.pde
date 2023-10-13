class secondSketch extends PApplet {
  boolean keyz[] = new boolean [9];

  void settings() {
    size(512, 424);
  }

  void setup() {
  }

  void draw() {
    checkKeys();
    background(0);
    image(img, 0, 0);
    fill(0);
    textSize(50);
    text(closestValue, 20, 45);
    textSize(20);
    text("presize", 20, 65);
    fill(255, 0, 0);
    ellipse(closestX, closestY, 20, 20);
    textSize(50);
    text(average, 150, 45);
    textSize(20);
    text("smooth", 150, 65);
    fill(0, 0, 255);
    textSize(50);
    text(videoPos, 280, 45);
    textSize(20);
    text("Frame", 280, 65);
    fill(0, 255, 255);
    textSize(50);
    text(sound, 410, 45);
    textSize(20);
    text("MIDI", 410, 65);
    stroke(0);

    fill(255, 0, 0);
    textSize(20);
    if (nearStart == true) {
      text("nearStart", 430, 165);
    }
    if (nearEnd == true) {
      text("nearEnd", 430, 165);
    }

    stroke(0);
    strokeWeight(1);
    noFill();
    rect(xStart, yStart, xEnd - xStart, yEnd - yStart);

    // draw direction arrows
    fill(255, 0, 0);
    noStroke();
    if (direction.equals("forwards")) {
      triangle(480, 212, 490, 262, 500, 212);
    }
    if (direction.equals("backwards")) {
      triangle(480, 212, 490, 162, 500, 212);
    }
  }

  void keyPressed() {
    if (key == 'h')  keyz[0] = true;
    if (key == 'l')  keyz[1] = true;
    if (key == 'r')  keyz[2] = true;
    if (key == 't')  keyz[3] = true;
    if (key == 'b')  keyz[4] = true;
    if (keyCode == LEFT)  keyz[5] = true;
    if (keyCode == RIGHT) keyz[6] = true;
    if (keyCode == UP)  keyz[7] = true;
    if (keyCode == DOWN) keyz[8] = true;
  }

  void keyReleased() {
    if (key == 'h')  keyz[0] = false;
    if (key == 'l')  keyz[1] = false;
    if (key == 'r')  keyz[2] = false;
    if (key == 't')  keyz[3] = false;
    if (key == 'b')  keyz[4] = false;
    if (keyCode == LEFT)  keyz[5] = false;
    if (keyCode == RIGHT) keyz[6] = false;
    if (keyCode == UP)  keyz[7] = false;
    if (keyCode == DOWN) keyz[8] = false;
  }


  void checkKeys() {
    if (keyz[0] == true) {
      println("menu");
      if (menu) {
        secondSketch.noLoop(); // Start the second sketch
        secondSketch.getSurface().setVisible(false);
      } else {
        secondSketch.loop(); // Start the second sketch
        secondSketch.getSurface().setVisible(true);
      }
      menu = !menu;  // Toggle the state
    };

    // Left sections
    if (keyz[1] == true && keyz[5] == true) {
      xStart = xStart -2;
    }
    if (keyz[1] == true && keyz[6] == true) {
      xStart = xStart +2;
    }

    // right section
    if (keyz[2] == true && keyz[5] == true) {
      xEnd = xEnd -2;
    }
    if (keyz[2] == true && keyz[6] == true) {
      xEnd = xEnd +2;
    }

    // top section
    if (keyz[3] == true && keyz[7] == true) {
      yStart = yStart -2;
    }
    if (keyz[3] == true && keyz[8] == true) {
      yStart = yStart +2;
    }

    // bottom section
    if (keyz[4] == true && keyz[7] == true) {
      yEnd = yEnd -2;
    }
    if (keyz[4] == true && keyz[8] == true) {
      yEnd = yEnd +2;
    }
  }
}
