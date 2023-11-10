import java.io.PrintWriter;

PrintWriter outputFile;


void loadSettings() {
  // Check if the file exists
  File file = new File(sketchPath("savedValues.txt"));
  
  if (file.exists()) {
    // Load values if the file exists
    String[] lines = loadStrings("savedValues.txt");
    if (lines.length >= 5) {
      println("FOUND DATA FILE");
      xStart = int(split(lines[0], ':')[1].trim());
      xEnd = int(split(lines[1], ':')[1].trim());
      yStart = int(split(lines[2], ':')[1].trim());
      yEnd = int(split(lines[3], ':')[1].trim());
      roomDepth = int(split(lines[4], ':')[1].trim());
    } else {
      println("INVALID DATA FILE, RESET VALUES");
      setDefaultValues();
    }
  } else {
    // Create the file and write default values
    println("DATA FILE NOT FOUND, CREATING AND WRITING DEFAULT VALUES");
    setDefaultValues();
    saveValuesToFile();
  }

  println("THE ROOM:" + roomDepth);
}

void setDefaultValues() {
  xStart = 100;
  xEnd = 512 - 100;
  yStart = 100;
  yEnd = 424 - 100;
  roomDepth = 4000;
}

void saveValuesToFile() {
  // Open a file for writing
  outputFile = createWriter("savedValues.txt");
  // Save xStart, xEnd, yStart, and yEnd to the text file
  outputFile.println("xStart: " + xStart);
  outputFile.println("xEnd: " + xEnd);
  outputFile.println("yStart: " + yStart);
  outputFile.println("yEnd: " + yEnd);
  outputFile.println("roomDepth: " + roomDepth);
  outputFile.flush();
  outputFile.close();
  println("SAVED VALUES TO FILE");
}



void keyPressed() {
  if (key == 'x')  keyz[0] = true;
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
  if (key == 'x') keyz[0] = false;
  if (key == 'a') keyz[1] = false;
  if (key == 'd') keyz[2] = false;
  if (key == 'w') keyz[3] = false;
  if (key == 's') keyz[4] = false;
  if (keyCode == LEFT)  keyz[5] = false;
  if (keyCode == RIGHT) keyz[6] = false;
  if (keyCode == UP)  keyz[7] = false;
  if (keyCode == DOWN) keyz[8] = false;
}
