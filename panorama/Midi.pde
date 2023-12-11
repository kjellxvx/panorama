import themidibus.*;
MidiBus mb;

import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;

// Define your mapping of videoPos range to note
HashMap<Range, MidiParameters> videoPosToMidi = new HashMap<>();
HashMap<String, Boolean> noteActive = new HashMap<>();
HashMap<String, Long> lastNoteTriggerTime = new HashMap<>();
HashMap<String, Long> lastVelocity = new HashMap<>();

class MidiParameters {
  int channel;
  int pitch;
  int fVelocityStart;
  int fVelocityEnd;
  boolean rewind;
  int bVelocityStart;
  int bVelocityEnd;
  boolean abort;
  long lastNoteTriggerTime;
  int lastVelocity;

  MidiParameters(int channel, int pitch, int fVelocityStart, int fVelocityEnd, boolean rewind, int bVelocityStart, int bVelocityEnd, boolean abort) {
    this.channel = channel;
    this.pitch = pitch;
    this.fVelocityStart = fVelocityStart;
    this.fVelocityEnd = fVelocityEnd;
    this.rewind = rewind;
    this.bVelocityStart = bVelocityStart;
    this.bVelocityEnd = bVelocityEnd;
    this.abort = abort;
    this.lastNoteTriggerTime = 0;
    this.lastVelocity = 0;
  }
}

class Range {
  int start;
  int end;

  Range(int start, int end) {
    this.start = start;
    this.end = end;
  }

  boolean contains(int value) {
    return value >= start && value <= end;
  }
}

int channel = 0;
int pitch = 0;
int velocity = 60;
int frameRange = 10;
int prevVideoPos = -1;
int noteTimeout = 50;
int backwardsShift = 36;

void initMidi() {
  try {
    MidiBus.list();
    mb = new MidiBus(this, -1, "CoreMIDI4J - IAC Driver");
    mb.sendTimestamps(false);


    // FORMAT Range (number - number) / channel / pitch / fowards velocity range 60 - 63 / backwards velocity range 60 - 63 / abort

    //Channel 1
    videoPosToMidi.put(new Range(536, 550), new MidiParameters(0, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(548, 557), new MidiParameters(0, 61, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(562, 574), new MidiParameters(0, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(583, 599), new MidiParameters(0, 63, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(615, 645), new MidiParameters(0, 64, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(674, 730), new MidiParameters(0, 65, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(774, 830), new MidiParameters(0, 66, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(826, 880), new MidiParameters(0, 67, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(898, 950), new MidiParameters(0, 68, 61, 63, true, 61, 63, true));
    
        //Channel 2
    videoPosToMidi.put(new Range(535, 565), new MidiParameters(1, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(585, 615), new MidiParameters(1, 61, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(613, 655), new MidiParameters(1, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(676, 730), new MidiParameters(1, 63, 61, 63, true, 61, 63, true));

    videoPosToMidi.put(new Range(778, 778+frameRange), new MidiParameters(1, 64, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(911, 911+frameRange), new MidiParameters(1, 65, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1167, 1167+frameRange), new MidiParameters(1, 66, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1073, 1073+frameRange), new MidiParameters(1, 67, 61, 63, true, 61, 63, true));

    //Channel 3
    videoPosToMidi.put(new Range(555, 555+frameRange), new MidiParameters(2, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(711, 711+frameRange), new MidiParameters(2, 61, 61, 63, true, 61, 63, true));

    videoPosToMidi.put(new Range(838, 838+frameRange), new MidiParameters(2, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(967, 967+frameRange), new MidiParameters(2, 63, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1090, 1090+frameRange), new MidiParameters(2, 64, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1267, 1267+frameRange), new MidiParameters(2, 65, 61, 63, true, 61, 63, true));

    //Channel 4
    videoPosToMidi.put(new Range(752, 910), new MidiParameters(3, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(915, 1080), new MidiParameters(3, 61, 61, 63, false, 0, 0, true));
    videoPosToMidi.put(new Range(1091, 1310), new MidiParameters(3, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1300, 1390), new MidiParameters(3, 63, 61, 63, false, 0, 0, true));

    //Channel 5
    videoPosToMidi.put(new Range(536, 536+frameRange), new MidiParameters(4, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(708, 708+frameRange), new MidiParameters(4, 61, 61, 63, true, 61, 63, true));

    videoPosToMidi.put(new Range(842, 1080), new MidiParameters(4, 62, 61, 63, true, 61, 63, true));

    //Channel 6
    videoPosToMidi.put(new Range(964, 1200), new MidiParameters(5, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1318, 1380), new MidiParameters(5, 61, 61, 63, true, 61, 63, true));

    //Channel 7
    videoPosToMidi.put(new Range(807, 864), new MidiParameters(6, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(884, 916), new MidiParameters(6, 61, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(950, 969), new MidiParameters(6, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1033, 1111), new MidiParameters(6, 63, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1107, 1107+frameRange), new MidiParameters(6, 64, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1156, 1204), new MidiParameters(6, 65, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1216, 1250), new MidiParameters(6, 66, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1351, 1351+frameRange), new MidiParameters(6, 67, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1215, 1244), new MidiParameters(6, 68, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1229, 1303), new MidiParameters(6, 69, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1260, 1277), new MidiParameters(6, 70, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1266, 1276), new MidiParameters(6, 71, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1279, 1279+frameRange), new MidiParameters(6, 72, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1310, 1385), new MidiParameters(6, 73, 61, 63, true, 61, 63, true));

    //Channel 14
    videoPosToMidi.put(new Range(5, 5+frameRange), new MidiParameters(13, 60, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(120, 120+frameRange), new MidiParameters(13, 61, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(212, 212+frameRange), new MidiParameters(13, 62, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(305, 305+frameRange), new MidiParameters(13, 63, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(401, 401+frameRange), new MidiParameters(13, 64, 61, 65, false, 0, 0, true));

    //Channel 15
    videoPosToMidi.put(new Range(5, 5+frameRange), new MidiParameters(14, 48, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(100, 100+frameRange), new MidiParameters(14, 49, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(200, 200+frameRange), new MidiParameters(14, 50, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(300, 300+frameRange), new MidiParameters(14, 51, 61, 65, false, 0, 0, true));
    videoPosToMidi.put(new Range(400, 400+frameRange), new MidiParameters(14, 52, 61, 65, false, 0, 0, true));

    videoPosToMidi.put(new Range(500, 500+frameRange), new MidiParameters(14, 60, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(600, 600+frameRange), new MidiParameters(14, 61, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(700, 700+frameRange), new MidiParameters(14, 62, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(800, 800+frameRange), new MidiParameters(14, 63, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(900, 900+frameRange), new MidiParameters(14, 64, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(1000, 1000+frameRange), new MidiParameters(14, 65, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(1100, 1100+frameRange), new MidiParameters(14, 66, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(1200, 1200+frameRange), new MidiParameters(14, 67, 61, 65, true, 61, 65, true));
    videoPosToMidi.put(new Range(1300, 1300+frameRange), new MidiParameters(14, 68, 61, 65, true, 61, 65, true));

    //Channel 16
    videoPosToMidi.put(new Range(10, 10+frameRange), new MidiParameters(15, 48, 61, 63, false, 0, 0, true));
    videoPosToMidi.put(new Range(110, 110+frameRange), new MidiParameters(15, 49, 61, 63, false, 0, 0, true));
    videoPosToMidi.put(new Range(210, 210+frameRange), new MidiParameters(15, 50, 61, 63, false, 0, 0, true));
    videoPosToMidi.put(new Range(310, 310+frameRange), new MidiParameters(15, 51, 61, 63, false, 0, 0, true));
    videoPosToMidi.put(new Range(410, 410+frameRange), new MidiParameters(15, 52, 61, 63, false, 0, 0, true));


    videoPosToMidi.put(new Range(510, 510+frameRange), new MidiParameters(15, 60, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(610, 610+frameRange), new MidiParameters(15, 61, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(710, 710+frameRange), new MidiParameters(15, 62, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(810, 810+frameRange), new MidiParameters(15, 63, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(910, 910+frameRange), new MidiParameters(15, 64, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1010, 1010+frameRange), new MidiParameters(15, 65, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1110, 1110+frameRange), new MidiParameters(15, 66, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1210, 1210+frameRange), new MidiParameters(15, 67, 61, 63, true, 61, 63, true));
    videoPosToMidi.put(new Range(1310, 1310+frameRange), new MidiParameters(15, 68, 61, 63, true, 61, 63, true));
  }
  catch (Exception e) {
    println("Error initializing MIDI: " + e.getMessage());
  }
}


void triggerNote() {
  long currentTime = millis();

  // Loop through each range
  for (Range range : videoPosToMidi.keySet()) {
    MidiParameters params = videoPosToMidi.get(range);


    String noteKey = "";
    String noteDirection = "";

    if (direction == "backwards") {
      noteDirection = "backwards";
      noteKey = params.channel + "-" + int(params.pitch + backwardsShift);
    } else if (direction == "forwards") {
      noteDirection = "forwards";
      noteKey= params.channel + "-" + params.pitch;
    }

    boolean isActive = noteActive.getOrDefault(noteKey, false);
    Long lastTrigger = lastNoteTriggerTime.getOrDefault(noteKey, 0L);
    Long lastVeloc = lastVelocity.getOrDefault(noteKey, 0L);

    if (range.contains(videoPos)) {
      if (!isActive && currentTime - lastTrigger >= noteTimeout && isMoving) {
        // Entering the range for this note and timeout has elapsed
        noteActive.put(noteKey, true);
        sendNoteOn(params, lastVeloc, noteDirection);
        lastNoteTriggerTime.put(noteKey, currentTime); // Update last trigger time on note on
      }
    } else if (isActive) {
      // Exiting the range for this note
      sendNoteOff(params, direction);
      noteActive.put(noteKey, false);
      lastNoteTriggerTime.put(noteKey, currentTime); // Update last trigger time on note off
    }
  }
  prevVideoPos = videoPos;
}


void abortNote() {
  // Get the current time
  long currentTime = millis();
  // Iterate through each video position range
  for (Range range : videoPosToMidi.keySet()) {
    // Get MIDI parameters for the current range
    MidiParameters params = videoPosToMidi.get(range);
    boolean shouldAbort = params.abort;

    // Forward abort
    String noteKeyForward = params.channel + "-" + params.pitch;
    boolean isActiveForward = noteActive.getOrDefault(noteKeyForward, false);
    // Check if the note is active and should be aborted in the forward direction
    if (isActiveForward && shouldAbort) {
      String abortDirectionForward = "forwards";
      // Send a note-off signal for the forward direction
      sendNoteOff(params, abortDirectionForward);
      // Update note activity status and trigger time for the forward direction
      noteActive.put(noteKeyForward, false);
      lastNoteTriggerTime.put(noteKeyForward, currentTime);
    }

    // Backward abort
    String noteKeyBackward = params.channel + "-" + int(params.pitch + backwardsShift);
    boolean isActiveBackward = noteActive.getOrDefault(noteKeyBackward, false);
    // Check if the note is active and should be aborted in the backward direction
    if (isActiveBackward && shouldAbort) {
      String abortDirectionBackward = "backwards";
      // Send a note-off signal for the backward direction
      sendNoteOff(params, abortDirectionBackward);
      // Update note activity status and trigger time for the backward direction
      noteActive.put(noteKeyBackward, false);
      lastNoteTriggerTime.put(noteKeyBackward, currentTime);
    }
  }
}

void sendNoteOn(MidiParameters params, long lastVeloc, String noteDirection) {
  try {
    if (noteDirection == "backwards" && params.rewind) {
      int backwardsVelo;
      do {
        backwardsVelo = int(random(params.bVelocityStart, params.bVelocityEnd + 1));
      } while (backwardsVelo == lastVeloc);
      pitch =params.pitch + backwardsShift;
      long newVeloc = backwardsVelo;
      String noteKey = params.channel + "-" + int(params.pitch + backwardsShift);
      mb.sendNoteOn(params.channel, int(params.pitch + backwardsShift), backwardsVelo);
      lastVelocity.put(noteKey, newVeloc);
      channel =params.channel;
      velocity = backwardsVelo;

      println("BACKWARDS <<< FRAME: " + videoPos+ " | Note ON: Channel " + (params.channel +1) + " | Pitch " + pitch + " | LastVelocity | " + lastVeloc +  " | NewVelocity " + newVeloc);
    } else if (noteDirection == "forwards") {
      int forwardsVelo;
      do {
        forwardsVelo = int(random(params.fVelocityStart, params.fVelocityEnd + 1));
      } while (forwardsVelo == lastVeloc);
      long newVeloc = forwardsVelo;
      String noteKey = params.channel + "-" + pitch;
      mb.sendNoteOn(params.channel, params.pitch, forwardsVelo);
      lastVelocity.put(noteKey, newVeloc);
      channel =params.channel;
      pitch =params.pitch;
      velocity = forwardsVelo;
      println("FORWARDS >>> FRAME: " + videoPos+ " | Note ON: Channel " + (params.channel +1) + " | Pitch " + pitch + " | LastVelocity | " + lastVeloc +  " | NewVelocity " + newVeloc);
    }
  }
  catch (Exception e) {
    println("Error sending Note On: " + e.getMessage());
  }
}

void sendNoteOff(MidiParameters params, String direction) {
  try {
    if (direction == "backwards") {
      mb.sendNoteOff(params.channel, (int(params.pitch + backwardsShift)), 0);
      println("----- OFF BACKWARDS >>> FRAME: " + videoPos+ " | Note ON: Channel " + (params.channel +1) + " | Pitch " + int(params.pitch + backwardsShift));
    } else if (direction == "forwards") {
      mb.sendNoteOff(params.channel, params.pitch, 0);
      println("----- OFF FORWARDS >>> FRAME: " + videoPos+ " | Note ON: Channel " + (params.channel +1) + " | Pitch " + params.pitch);
    }
  }
  catch (Exception e) {
    println("Error sending Note Off: " + e.getMessage());
  }
}
