class secondSketch extends PApplet {
    boolean keyz[] = new boolean[9];
    int wH = 424;
    int wW = 512;
    int statsHeight = 200;
    String selected = "none";
    
    void settings() {
        size(512, 424 + 200);
    }
    
    void setup() {
        cp5 = new ControlP5(this);
        cp5.addSlider("roomDepth")
           .setPosition(10, 600)
           .setSize(200, 20)
           .setRange(0, 8000)
           .setValue(4000)
           .setColorForeground(color(255))
           .setColorBackground(color(100))
           .setColorValueLabel(color(0))
           .setLabel("Room Depth");
    }
    
    void draw() {
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
    
    void keyPressed() {
        if (key == 'h')  keyz[0] = true;
        if (key == 'a')  keyz[1] = true;
        if (key == 'd')  keyz[2] = true;
        if (key == 'w')  keyz[3] = true;
        if (key == 's')  keyz[4] = true;
        if (keyCode == LEFT)  keyz[5] = true;
        if (keyCode == RIGHT) keyz[6] = true;
        if (keyCode == UP)  keyz[7] = true;
        if (keyCode == DOWN) keyz[8] = true;
    }
    
    void keyReleased() {
        if (key == 'h') keyz[0] = false;
        if (key == 'a') keyz[1] = false;
        if (key == 'd') keyz[2] = false;
        if (key == 'w') keyz[3] = false;
        if (key == 's') keyz[4] = false;
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
                saveValuesToFile();
            } else {
                secondSketch.loop();// Start the second sketch
                secondSketch.getSurface().setVisible(true);
            }
            menu = !menu;  // Toggle the state
        };
        
        if (keyz[1] == true) {
            selected = "left";
            if (keyz[5] == true) {xStart = xStart - 2;}
            else if (keyz[6] == true) {xStart = xStart + 2;}
        } 
        
        else if (keyz[2] == true) {
            selected = "right";
            if (keyz[5] == true) {xEnd = xEnd - 2;}
            else if (keyz[6] == true) {xEnd = xEnd + 2;}
        } 
        
        else if (keyz[3] == true) {
            selected = "top";
            if (keyz[7] == true) {  yStart = yStart - 2;}
            else if (keyz[8] == true) {yStart = yStart + 2;}
        } 
        
        else if (keyz[4] == true) {
            selected = "bottom";
            if (keyz[7] == true) {yEnd = yEnd - 2;}
            else if (keyz[8] == true) {yEnd = yEnd + 2;}
        } else {
            selected = "none";
        }
    }
    
    void controlEvent(ControlEvent theEvent) {
       if (theEvent.isFrom("roomDepth")) {
            roomDepth = int(theEvent.getController().getValue());
        }
    }
    }
        
